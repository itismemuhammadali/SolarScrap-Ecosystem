import uuid
from datetime import datetime, timezone, timedelta
from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends, status, Query
from firebase_admin import firestore

from app.schemas.auth import UserProfile, UserRole
from app.schemas.admin import (
    DashboardStatsResponse,
    StatCardItem,
    UserGrowthPoint,
    UserStatusBreakdown,
    BidActivityWeek,
    CityLeadItem,
    RecentActivityItem,
    AdminUserItem,
    UpdateUserStatusRequest,
    AdminLeadItem,
    UpdateLeadRequest,
    AdminSellerPostItem,
    UpdateSellerPostRequest,
    CreateAdminAuctionRequest,
)
from app.api.auth import get_current_user
from app.api.notifications import create_user_notification, create_admin_notification
from app.core.firebase import get_firestore_db


router = APIRouter(prefix="/admin", tags=["Admin"])


def _format_dt(dt):
    if dt is None:
        return ""
    if hasattr(dt, "strftime"):
        return dt.strftime("%Y-%m-%d")
    return str(dt)[:10]


@router.get("/dashboard-stats", response_model=DashboardStatsResponse)
async def get_dashboard_stats(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Returns aggregated live platform analytics, stat card counters,
    charts data, and recent activity feed for the Admin dashboard.
    """
    db = get_firestore_db()

    # 1. Fetch Users
    users_docs = list(db.collection("users").stream())
    sellers_count = 0
    dealers_count = 0
    pending_users = 0
    approved_users = 0
    rejected_users = 0

    recent_user_events = []

    for doc in users_docs:
        data = doc.to_dict() or {}
        role = str(data.get("role", "")).lower()
        user_status = str(data.get("status", "approved")).lower()

        if role == "seller":
            sellers_count += 1
        elif role in ("buyer", "dealer"):
            dealers_count += 1

        if user_status == "pending":
            pending_users += 1
        elif user_status == "rejected":
            rejected_users += 1
        else:
            approved_users += 1

        created = data.get("created_at")
        name = data.get("display_name") or data.get("company_name") or data.get("email", "User")
        recent_user_events.append({
            "id": doc.id,
            "title": f"{name} registered as a {role.capitalize() if role else 'User'}",
            "time": _format_dt(created) or "Recent",
            "type": "user",
            "raw_time": created,
        })

    # 2. Fetch Listings
    listings_docs = list(db.collection("listings").stream())
    pending_posts = 0
    active_auctions = 0
    recent_listing_events = []

    for doc in listings_docs:
        data = doc.to_dict() or {}
        listing_status = str(data.get("status", "active")).lower()
        post_status = str(data.get("post_status", "")).lower()
        if listing_status in ("pending", "under_review", "new") or post_status in ("pending", "under review", "new"):
            pending_posts += 1
        elif listing_status in ("active", "auction") or post_status in ("auction", "active", "approved"):
            active_auctions += 1

        category = data.get("category", "Equipment")
        created = data.get("created_at")
        seller_name = data.get("contact_name") or "Seller"
        recent_listing_events.append({
            "id": doc.id,
            "title": f"{seller_name} submitted new scrap post — {category}",
            "time": _format_dt(created) or "Recent",
            "type": "post",
            "raw_time": created,
        })

    # 3. Fetch Bids
    bids_docs = list(db.collection("bids").stream())
    total_bids = len(bids_docs)
    recent_bid_events = []

    for doc in bids_docs:
        data = doc.to_dict() or {}
        buyer_name = data.get("buyer_name", "Dealer")
        amount = int(float(data.get("amount", 0)))
        title = data.get("listing_title", "Auction")
        created = data.get("created_at")
        recent_bid_events.append({
            "id": doc.id,
            "title": f"{buyer_name} placed a bid of PKR {amount:,} on {title}",
            "time": _format_dt(created) or "Recent",
            "type": "bid",
            "raw_time": created,
        })

    # 4. Fetch Facebook Leads
    leads_docs = list(db.collection("facebook_leads").stream())
    facebook_leads_count = len(leads_docs)
    recent_lead_events = []

    city_map = {}
    for doc in leads_docs:
        data = doc.to_dict() or {}
        city = data.get("city", "Karachi")
        city_map[city] = city_map.get(city, 0) + 1

        name = data.get("name", "Lead")
        created = data.get("created_at")
        recent_lead_events.append({
            "id": doc.id,
            "title": f"New Facebook lead — {name}, {city}",
            "time": _format_dt(created) or "Recent",
            "type": "lead",
            "raw_time": created,
        })

    max_city_count = max(city_map.values()) if city_map else 1
    city_leads = [
        CityLeadItem(
            city=city,
            count=count,
            percentage=min(100, int((count / max_city_count) * 90)),
        )
        for city, count in sorted(city_map.items(), key=lambda x: x[1], reverse=True)[:5]
    ]

    # Combine Recent Activity (Top 6 latest dynamic events)
    all_events = recent_bid_events + recent_listing_events + recent_user_events + recent_lead_events
    recent_activities = [
        RecentActivityItem(
            id=ev["id"],
            title=ev["title"],
            time=ev["time"],
            type=ev["type"],
        )
        for ev in all_events[:6]
    ]

    # Dynamic User Growth
    months = ["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    user_growth = [
        UserGrowthPoint(month=m, sellers=0, dealers=0)
        for m in months
    ]
    if user_growth:
        user_growth[-1].sellers = sellers_count
        user_growth[-1].dealers = dealers_count

    # Dynamic Bid Activity
    weeks = ["W1", "W2", "W3", "W4", "W5", "W6"]
    bid_activity = [
        BidActivityWeek(week=w, count=0, height_pct=0)
        for w in weeks
    ]
    if bid_activity:
        bid_activity[-1].count = total_bids
        bid_activity[-1].height_pct = min(100, max(20, total_bids * 10)) if total_bids > 0 else 0

    # Clean dynamic numbers for stat cards
    return DashboardStatsResponse(
        stats=StatCardItem(
            total_sellers=sellers_count,
            total_dealers=dealers_count,
            pending_approvals=pending_users,
            pending_posts=pending_posts,
            active_auctions=active_auctions,
            total_bids=total_bids,
            facebook_leads=facebook_leads_count,
        ),
        user_growth=user_growth,
        user_status=UserStatusBreakdown(
            approved=approved_users,
            pending=pending_users,
            rejected=rejected_users,
        ),
        bid_activity=bid_activity,
        city_leads=city_leads,
        recent_activities=recent_activities,
    )


@router.get("/users", response_model=List[AdminUserItem])
async def get_admin_users(
    role: Optional[str] = Query(None, description="'seller' or 'buyer'"),
    status: Optional[str] = Query(None, description="'Pending', 'Approved', or 'Rejected'"),
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch users for the Sellers or Scrap Dealers tables with filtering.
    """
    db = get_firestore_db()
    users_ref = db.collection("users")

    query = users_ref
    if role:
        query = query.where("role", "==", role.lower())

    results = []
    for doc in query.stream():
        data = doc.to_dict() or {}
        user_status_raw = data.get("status", "Approved")
        # Normalize status to Title case
        norm_status = user_status_raw.capitalize()
        if status and norm_status.lower() != status.lower():
            continue

        name = data.get("display_name") or data.get("email", "User").split("@")[0].capitalize()
        letter = name[0].upper() if name else "U"
        company = data.get("company_name") or "Independent"

        created = data.get("created_at")
        joined_str = _format_dt(created) or "2024-12-01"

        photo_url = data.get("profile_photo_url") or data.get("photo_url") or data.get("avatar_url")

        results.append(
            AdminUserItem(
                id=doc.id,
                name=name,
                avatar_letter=letter,
                company=company,
                email=data.get("email", ""),
                phone=data.get("phone_number") or "+92 300 0000000",
                status=norm_status,
                activity_status="Active",
                joined=joined_str,
                role=data.get("role", "seller").capitalize(),
                city=data.get("city") or "Karachi",
                area=data.get("area") or "Industrial Area",
                profile_photo_url=photo_url,
            )
        )

    return results

    return results


@router.patch("/users/{user_id}/status")
async def update_user_status(
    user_id: str,
    payload: UpdateUserStatusRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Approve or reject a seller/dealer account.
    """
    db = get_firestore_db()
    user_ref = db.collection("users").document(user_id)
    doc = user_ref.get()

    new_status = payload.status.capitalize()
    if doc.exists:
        user_ref.update({
            "status": new_status,
            "updated_at": firestore.SERVER_TIMESTAMP,
        })
        # Send in-app notification to the user
        is_approved = new_status.lower() == "approved"
        create_user_notification(
            db=db,
            user_id=user_id,
            notif_type="account_verified" if is_approved else "account_status",
            title="Account Verified!" if is_approved else f"Account {new_status}!",
            description=(
                "Your account registration has been approved and verified by the Solar Scrap Admin team. You now have full access."
                if is_approved
                else f"Your account registration has been {new_status.lower()} by the Solar Scrap Admin team."
            ),
        )
    return {"message": f"User status successfully updated to {new_status}", "user_id": user_id, "status": new_status}


@router.get("/leads", response_model=List[AdminLeadItem])
async def get_facebook_leads(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all incoming Facebook/Meta campaign leads.
    """
    db = get_firestore_db()
    leads_ref = db.collection("facebook_leads")
    docs = list(leads_ref.stream())

    results = []
    for doc in docs:
        data = doc.to_dict() or {}
        created = data.get("created_at")
        results.append(
            AdminLeadItem(
                id=doc.id,
                lead_id=data.get("lead_id", f"FB{str(doc.id)[:3].upper()}"),
                name=data.get("name", "Customer"),
                phone=data.get("phone", ""),
                email=data.get("email", ""),
                city=data.get("city", "Karachi"),
                area=data.get("area", ""),
                received_date=_format_dt(created) or "2024-12-07",
                status=data.get("status", "New"),
                source=data.get("source", "Facebook Campaign"),
                notes=data.get("notes", []),
            )
        )

    return results


@router.patch("/leads/{lead_id}")
async def update_lead(
    lead_id: str,
    payload: UpdateLeadRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Update a Facebook lead's status or add a follow-up note.
    """
    db = get_firestore_db()
    lead_ref = db.collection("facebook_leads").document(lead_id)
    doc = lead_ref.get()

    if not doc.exists:
        docs = list(db.collection("facebook_leads").where("lead_id", "==", lead_id).stream())
        if docs:
            lead_ref = docs[0].reference
            doc = lead_ref.get()
        else:
            raise HTTPException(status_code=404, detail="Lead not found")

    update_data = {}
    if payload.status:
        update_data["status"] = payload.status
    if payload.note:
        existing_notes = doc.to_dict().get("notes", [])
        existing_notes.append(f"{datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M')}: {payload.note}")
        update_data["notes"] = existing_notes

    if update_data:
        update_data["updated_at"] = firestore.SERVER_TIMESTAMP
        lead_ref.update(update_data)

    return {"message": "Lead updated successfully", "lead_id": lead_id}


@router.post("/leads")
async def create_lead(
    payload: dict,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Manually create or simulate an incoming Meta/Facebook lead.
    """
    db = get_firestore_db()
    lead_id = f"FB-{uuid.uuid4().hex[:4].upper()}"
    doc_id = f"lead_{uuid.uuid4().hex[:8]}"
    data = {
        "lead_id": lead_id,
        "name": payload.get("name", "New Lead"),
        "phone": payload.get("phone", "+92 300 1234567"),
        "email": payload.get("email", ""),
        "city": payload.get("city", "Karachi"),
        "area": payload.get("area", "Industrial Area"),
        "status": payload.get("status", "New"),
        "source": payload.get("source", "Meta / Facebook Ad Campaign"),
        "notes": payload.get("notes", ["Inquiry submitted via Meta Lead Ad"]),
        "created_at": firestore.SERVER_TIMESTAMP,
        "received_date": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
    }
    db.collection("facebook_leads").document(doc_id).set(data)
    data["id"] = doc_id
    return data


@router.post("/leads/public")
async def submit_public_lead(payload: dict):
    """
    Public endpoint for incoming leads submitted via Meta / Facebook Ads landing form.
    Does not require admin authentication.
    """
    db = get_firestore_db()
    lead_id = f"FB-{uuid.uuid4().hex[:4].upper()}"
    doc_id = f"lead_{uuid.uuid4().hex[:8]}"

    name = payload.get("name", "New Lead").strip()
    phone = payload.get("phone", "").strip()
    email = payload.get("email", "").strip()
    city = payload.get("city", "Karachi").strip()
    area = payload.get("area", "").strip()
    category = payload.get("category", "Solar Scrap").strip()
    quantity = payload.get("quantity", "").strip()
    specs = payload.get("specs", "").strip()
    asking_price = payload.get("asking_price") or payload.get("price", "")
    remarks = payload.get("remarks") or payload.get("description", "").strip()
    intent = payload.get("intent", "Selling Scrap").strip()

    note_lines = [
        f"Intent: {intent}",
        f"Category: {category}",
    ]
    if quantity:
        note_lines.append(f"Quantity / Volume: {quantity}")
    if specs:
        note_lines.append(f"Condition/Specs: {specs}")
    if asking_price:
        note_lines.append(f"Asking Price: PKR {asking_price}")
    if remarks:
        note_lines.append(f"Details: {remarks}")

    data = {
        "lead_id": lead_id,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "area": area,
        "category": category,
        "quantity": quantity,
        "specs": specs,
        "asking_price": asking_price,
        "remarks": remarks,
        "intent": intent,
        "status": "New",
        "source": payload.get("source", "Meta / Facebook Ad Campaign"),
        "notes": [
            "Inquiry submitted via Meta / Facebook Ad Lead Form",
            " | ".join(note_lines),
        ],
        "created_at": firestore.SERVER_TIMESTAMP,
        "received_date": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
    }

    db.collection("facebook_leads").document(doc_id).set(data)

    # Trigger admin notification
    try:
        db.collection("admin_notifications").document(f"notif_{uuid.uuid4().hex[:8]}").set({
            "type": "lead",
            "title": f"New Meta Lead: {name}",
            "description": f"New Facebook Ad lead from {city} for {category} ({phone})",
            "entity_id": doc_id,
            "entity_type": "facebook_lead",
            "is_read": False,
            "created_at": firestore.SERVER_TIMESTAMP,
        })
    except Exception:
        pass

    return {
        "success": True,
        "message": "Lead submitted successfully",
        "lead_id": lead_id,
        "id": doc_id,
        "data": {
            "lead_id": lead_id,
            "name": name,
            "phone": phone,
            "city": city,
            "category": category,
        },
    }


@router.get("/posts", response_model=List[AdminSellerPostItem])
async def get_admin_seller_posts(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all seller posts / listings for review, pricing, and auction creation.
    """
    db = get_firestore_db()
    docs = list(db.collection("listings").stream())
    posts = []

    users_cache = {}

    for doc in docs:
        data = doc.to_dict() or {}
        seller_id = data.get("seller_id", "")

        # Exclude auctions created by Admin (they go directly to live Auctions, not Seller Posts)
        if data.get("created_by") == "admin" or data.get("created_by_admin") is True:
            continue
        if data.get("is_auction") is True and not data.get("post_id") and (data.get("contact_name") in ("Solar Scrap Admin", "Admin Platform") or seller_id in ("admin_system", "nZh63CylxzZx40ldIYuP0SQ5cEN2", "n5hyLFINq0WXBRv1pV2oMbhrMz52")):
            continue

        specs = data.get("specs") or {}
        seller_data = {}

        if seller_id:
            if seller_id in users_cache:
                seller_data = users_cache[seller_id]
            else:
                try:
                    u_doc = db.collection("users").document(seller_id).get()
                    if u_doc.exists:
                        seller_data = u_doc.to_dict() or {}
                    users_cache[seller_id] = seller_data
                except Exception:
                    pass

        category = data.get("category", "Solar Scrap")
        if category == "Solar Panels":
            panels_count = specs.get("panels_count") or specs.get("quantity") or 1
            watts = specs.get("watts_per_panel") or ""
            title = f"{panels_count}x {watts}W Solar Panels" if watts else f"{panels_count}x Solar Panels"
            qty = int(panels_count) if str(panels_count).isdigit() else 1
            condition = specs.get("panel_condition", "Used")
        elif category == "Inverter":
            qty = int(specs.get("inverters_count") or 1)
            capacity = specs.get("capacity_kw") or ""
            title = f"{qty}x {capacity}kW Inverter" if capacity else f"{qty}x Inverter"
            condition = specs.get("inverter_condition", "Used")
        elif category == "Battery":
            qty = int(specs.get("batteries_count") or 1)
            battery_type = specs.get("battery_type") or "Battery"
            title = f"{qty}x {battery_type}"
            condition = specs.get("battery_condition", "Used")
        else:
            title = data.get("title") or f"{category} Listing"
            qty = int(specs.get("quantity") or 1)
            condition = data.get("condition") or "Used"

        status_val = data.get("post_status") or ("Approved" if data.get("status") in ("active", "approved") else "New")
        if status_val in ("Pending Approval", "pending", "Pending"):
            status_val = "New"
        raw_price = data.get("price_demand") or data.get("price_expected") or 0.0

        post_code = data.get("post_id")
        if not post_code:
            if doc.id == "listing_seed_01":
                post_code = "SP001"
            elif "seed_0" in doc.id:
                post_code = f"SP00{doc.id[-1]}"
            else:
                post_code = f"PST-{doc.id[:6].upper()}"

        posts.append(
            AdminSellerPostItem(
                id=doc.id,
                post_id=post_code,
                title=title,
                category=category,
                qty=qty,
                condition=condition,
                status=status_val,
                price_expected=float(raw_price),
                offered_price=data.get("offered_price"),
                submitted_date=_format_dt(data.get("created_at")),
                seller_name=data.get("contact_name") or seller_data.get("full_name") or "Seller",
                seller_company=data.get("contact_company") or seller_data.get("company_name") or "Individual",
                seller_email=data.get("contact_email") or seller_data.get("email") or "",
                seller_phone=data.get("contact_phone") or seller_data.get("phone_number") or "",
                city=data.get("pickup_city") or "Karachi",
                area=data.get("pickup_area") or "",
                address=data.get("pickup_address") or "",
                brand_model=specs.get("brand") or specs.get("model") or "Generic",
                estimated_weight=specs.get("estimated_weight") or (f"{qty * 20} kg" if category == "Solar Panels" else "-"),
                disassembly_state=specs.get("disassembly_state") or "Dismantled",
                images=data.get("image_urls") or [],
                watts_per_unit=str(specs.get("watts_per_panel") or specs.get("watts_per_unit") or ("400W" if category == "Solar Panels" else "")),
                manufacturer=specs.get("manufacturer") or specs.get("brand") or "Waaree Energies",
                purchase_year=str(specs.get("purchase_year") or "2019"),
                reason_for_sale=specs.get("reason_for_sale") or "Project Decommission",
                admin_notes=data.get("admin_notes"),
            )
        )

    posts.sort(key=lambda p: p.submitted_date, reverse=True)
    return posts


@router.patch("/posts/{post_id}")
async def update_seller_post(
    post_id: str,
    payload: UpdateSellerPostRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Update a seller post status, offer price, or admin notes.
    Sends notifications to seller when price is offered or post is moved to auction.
    """
    db = get_firestore_db()
    doc_ref = db.collection("listings").document(post_id)
    doc = doc_ref.get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Seller post not found")

    data = doc.to_dict() or {}
    updates = {}
    if payload.status is not None:
        if payload.status in ("Approved", "approved", "active"):
            updates["status"] = "active"
            updates["post_status"] = "Approved"
        elif payload.status in ("Rejected", "rejected"):
            updates["status"] = "rejected"
            updates["post_status"] = "Rejected"
        elif payload.status in ("Auction", "auction"):
            updates["status"] = "auction"
            updates["post_status"] = "Auction"
            updates["is_auction"] = True
            if not data.get("auction_id"):
                import random
                updates["auction_id"] = f"AUC{random.randint(100, 999)}"
        else:
            updates["status"] = payload.status
            updates["post_status"] = payload.status
    if payload.offered_price is not None:
        updates["offered_price"] = payload.offered_price
    if payload.admin_notes is not None:
        updates["admin_notes"] = payload.admin_notes
    if payload.starting_price is not None:
        updates["starting_price"] = float(payload.starting_price)
        updates["starting_bid"] = float(payload.starting_price)
    if payload.duration is not None:
        updates["duration"] = payload.duration
        updates["ends_in"] = payload.duration
    if payload.ends_in is not None:
        updates["ends_in"] = payload.ends_in

    updates["updated_at"] = firestore.SERVER_TIMESTAMP
    doc_ref.update(updates)

    seller_id = data.get("seller_id")
    offered_amt = payload.offered_price if payload.offered_price is not None else data.get("offered_price")

    # If an offer price is set or status is "Price Offered", sync it as an official Quotation Bid
    if offered_amt is not None and (payload.status == "Price Offered" or payload.offered_price is not None):
        existing_bids = list(
            db.collection("bids")
            .where("listing_id", "==", post_id)
            .stream()
        )
        admin_bid_doc = None
        for b in existing_bids:
            b_dict = b.to_dict() or {}
            if b_dict.get("buyer_id") == "admin_system":
                admin_bid_doc = b
                break

        if admin_bid_doc:
            db.collection("bids").document(admin_bid_doc.id).update({
                "amount": float(offered_amt),
                "status": "pending",
                "notes": payload.admin_notes or "Official purchase quotation from SolarScrap Admin.",
                "updated_at": firestore.SERVER_TIMESTAMP,
            })
        else:
            category = data.get("category", "Solar Panels")
            specs = data.get("specs") or {}
            image_urls = data.get("image_urls") or []
            first_image = image_urls[0] if image_urls else None
            if category == "Solar Panels" and "panels_count" in specs:
                display_title = f"{specs.get('panels_count')}x Solar Panels ({specs.get('watts_per_panel', '')}W)"
            else:
                display_title = data.get("title") or f"{category} Listing"

            ref_id = f"QTN-{post_id[:6].upper()}"
            new_bid_data = {
                "listing_id": post_id,
                "seller_id": seller_id or "",
                "buyer_id": "admin_system",
                "buyer_name": "SolarScrap Admin (Quotation)",
                "amount": float(offered_amt),
                "status": "pending",
                "reference_number": ref_id,
                "listing_title": display_title,
                "listing_category": category,
                "listing_image": first_image,
                "notes": payload.admin_notes or "Official purchase quotation from SolarScrap Admin.",
                "created_at": firestore.SERVER_TIMESTAMP,
                "updated_at": firestore.SERVER_TIMESTAMP,
            }
            db.collection("bids").add(new_bid_data)

    if seller_id:
        if payload.offered_price is not None and payload.status == "Price Offered":
            create_user_notification(
                db,
                user_id=seller_id,
                notif_type="offer",
                title="Price Offer Received",
                description=f"SolarScrap Admin offered Rs. {int(payload.offered_price):,} for your listing.",
                listing_id=post_id,
            )
        elif payload.status == "Auction":
            create_user_notification(
                db,
                user_id=seller_id,
                notif_type="auction",
                title="Listing Live on Auction",
                description="Your scrap listing has been approved and moved to live bidding!",
                listing_id=post_id,
            )
        elif payload.status in ("Approved", "approved", "active"):
            create_user_notification(
                db,
                user_id=seller_id,
                notif_type="post_approved",
                title="Listing Approved & Live!",
                description="Your scrap listing has been approved by admin and is now active on the marketplace.",
                listing_id=post_id,
            )
        elif payload.status in ("Rejected", "rejected"):
            create_user_notification(
                db,
                user_id=seller_id,
                notif_type="post_rejected",
                title="Listing Rejected",
                description="Your scrap listing was rejected by admin. Please contact support or update details.",
                listing_id=post_id,
            )

    res = {"message": "Seller post updated successfully", "id": post_id}
    if payload.status is not None:
        res["status"] = payload.status
    if payload.offered_price is not None:
        res["offered_price"] = payload.offered_price
    if payload.admin_notes is not None:
        res["admin_notes"] = payload.admin_notes
    return res


@router.post("/seed-demo-data")
async def seed_demo_data(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Clean up any legacy demo data from Firestore emulator to maintain real database state.
    """
    db = get_firestore_db()
    preserve_uids = {'wlxmmr3GgmeZcgLqmqWSdol3pYGJ', 'gufUx0ITPqASRQRhPvnyapAyt5Od', 'buKESSIQVNiMCquQH8cBNeqiUXMf', 'MsPjAY0Q82rTk5xdiQ8Pi9z9IjDM'}

    for u in list(db.collection("users").stream()):
        if u.id not in preserve_uids and (u.id.startswith("seller_demo") or u.id.startswith("dealer_demo") or u.id in ("8EjJwt4zfFNY2O2K04f7zba090Eg", "r9cbn8EIdQNkqLeZ3y0m6xFWjZvP")):
            db.collection("users").document(u.id).delete()

    for l in list(db.collection("listings").stream()):
        if l.id.startswith("listing_demo"):
            db.collection("listings").document(l.id).delete()

    for b in list(db.collection("bids").stream()):
        if b.id.startswith("bid_demo"):
            db.collection("bids").document(b.id).delete()

    for ld in list(db.collection("facebook_leads").stream()):
        if ld.id.startswith("lead_demo"):
            db.collection("facebook_leads").document(ld.id).delete()

    return {"message": "Database cleaned. Only real accounts preserved."}


@router.get("/auctions")
async def get_admin_auctions(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all marketplace auctions for the admin portal with live bids,
    highest bidder metrics, and complete bid history.
    """
    db = get_firestore_db()

    # 1. Fetch all listings (sorted newest first)
    listings_docs = list(db.collection("listings").stream())
    def _doc_sort_key(doc):
        dt = (doc.to_dict() or {}).get("created_at")
        if not dt:
            return ""
        if hasattr(dt, "isoformat"):
            return dt.isoformat()
        return str(dt)
    listings_docs.sort(key=_doc_sort_key, reverse=True)

    # 2. Fetch all bids and group by listing_id
    bids_docs = list(db.collection("bids").stream())
    bids_by_listing = {}
    for b in bids_docs:
        bd = b.to_dict() or {}
        bd["id"] = b.id
        lid = bd.get("listing_id")
        if lid:
            if lid not in bids_by_listing:
                bids_by_listing[lid] = []
            bids_by_listing[lid].append(bd)

    # 3. Format each listing into an AuctionItem
    results = []
    for doc in listings_docs:
        l_data = doc.to_dict() or {}
        lid = doc.id
        specs = l_data.get("specs", {}) or {}
        category = l_data.get("category", "Solar Panels")

        # Dynamic Title
        title = l_data.get("title")
        if not title:
            if category == "Solar Panels" and "panels_count" in specs:
                title = f"{specs.get('panels_count')}x Solar Panels {specs.get('watts_per_panel', '')}W"
            elif category == "Inverters" and ("inverter_brand" in specs or "brand" in specs):
                brand = specs.get("inverter_brand") or specs.get("brand", "")
                power = specs.get("rated_power", "")
                title = f"{power} {brand}".strip() or "Solar Inverter"
            elif category == "Batteries" and ("battery_count" in specs or "count" in specs):
                count = specs.get("battery_count") or specs.get("count", "")
                b_type = specs.get("battery_type") or specs.get("type", "")
                title = f"{count}x {b_type} Batteries".strip()
            elif category == "Cables":
                title = f"Solar DC/AC Cables {specs.get('size', '')}".strip() or "Solar Cables"
            elif category == "Structure":
                title = f"{specs.get('structure_type', '')} Solar Mounting Structure".strip() or "Solar Structure"
            else:
                title = f"{category} Lot"

        # Dynamic Quantity
        qty = l_data.get("qty")
        if not qty:
            if category == "Solar Panels" and "panels_count" in specs:
                qty = f"{specs.get('panels_count')} Units"
            elif category == "Inverters":
                qty = specs.get("rated_power", "1 Unit")
            elif category == "Batteries" and ("battery_count" in specs or "count" in specs):
                qty = f"{specs.get('battery_count') or specs.get('count')} Units"
            else:
                qty = "1 Lot"

        # Bids for this listing (sorted highest amount first)
        listing_bids = bids_by_listing.get(lid, [])
        listing_bids.sort(key=lambda x: float(x.get("amount", 0.0)), reverse=True)

        total_bids = len(listing_bids)
        current_high_bid = float(listing_bids[0].get("amount", 0.0)) if listing_bids else float(l_data.get("current_high_bid", 0.0))

        highest_bidder_name = l_data.get("highest_bidder_name") or "No Bids Yet"
        highest_bidder_company = l_data.get("highest_bidder_company") or "Pending Verification"
        highest_bidder_city = l_data.get("highest_bidder_city") or l_data.get("pickup_city", "Karachi")
        highest_bidder_phone = l_data.get("highest_bidder_phone") or ""
        highest_bidder_email = l_data.get("highest_bidder_email") or ""

        if listing_bids:
            top_bid = listing_bids[0]
            highest_bidder_name = top_bid.get("buyer_name") or "Verified Buyer"
            highest_bidder_company = top_bid.get("buyer_company") or "Scrap Trading Co."
            highest_bidder_city = top_bid.get("buyer_city") or l_data.get("pickup_city", "Karachi")
            highest_bidder_phone = top_bid.get("buyer_phone") or ""
            highest_bidder_email = top_bid.get("buyer_email") or ""

        price_demand = float(l_data.get("price_demand", 0.0))
        starting_price = float(
            l_data.get("starting_price")
            or l_data.get("starting_bid")
            or (price_demand * 0.85 if price_demand > 0 else 100000)
        )
        starting_bid = starting_price
        reserve_price = float(l_data.get("reserve_price", price_demand * 0.9 if price_demand > 0 else starting_price))

        status_val = str(l_data.get("status", "active")).lower()
        post_status_val = str(l_data.get("post_status", "")).lower()

        if (
            status_val in ("active", "approved", "auction", "live")
            or post_status_val in ("auction", "active", "approved", "live")
            or l_data.get("is_auction") is True
        ):
            ui_status = "Active"
        elif status_val in ("closed", "sold") or post_status_val in ("closed", "sold"):
            ui_status = "Closed"
        else:
            ui_status = "Draft"

        ends_in = l_data.get("ends_in") or l_data.get("duration") or "3d 12h"
        end_date = l_data.get("end_date") or "Live"

        # Format individual bids list
        formatted_bids = []
        for idx, b in enumerate(listing_bids):
            formatted_bids.append({
                "id": b.get("id"),
                "bidderName": b.get("buyer_name") or "Verified Buyer",
                "bidderCompany": b.get("buyer_company") or "Scrap Trading Co.",
                "bidderCity": b.get("buyer_city") or "Karachi",
                "bidderPhone": b.get("buyer_phone") or "",
                "bidderEmail": b.get("buyer_email") or "",
                "amount": float(b.get("amount", 0.0)),
                "status": "Winner" if b.get("status") == "accepted" else ("Leading" if idx == 0 else "Outbid"),
                "createdAt": _format_dt(b.get("created_at")) or "Recent",
                "referenceNumber": b.get("reference_number") or f"BID-{b.get('id', '')[:6].upper()}",
            })

        category_color = "bg-blue-50 text-blue-700 border-blue-200"
        if category == "Inverters":
            category_color = "bg-amber-50 text-amber-700 border-amber-200"
        elif category == "Batteries":
            category_color = "bg-emerald-50 text-emerald-700 border-emerald-200"
        elif category in ("Complete System", "Complete Solar System"):
            category_color = "bg-purple-50 text-purple-700 border-purple-200"

        icon = "☀️"
        if category == "Inverters":
            icon = "⚡"
        elif category == "Batteries":
            icon = "🔋"
        elif category == "Cables":
            icon = "🔌"
        elif category == "Structure":
            icon = "🏗️"

        image_urls = l_data.get("image_urls") or []
        if not image_urls:
            image_urls = ["/images/solar-panel.png"]

        auc_idx = len(results) + 1
        custom_auc = l_data.get("auction_id")
        if custom_auc and not str(custom_auc).upper().startswith("AUC-LISTIN"):
            auction_id_str = custom_auc
        else:
            auction_id_str = f"AUC{auc_idx:03d}"

        results.append({
            "id": lid,
            "auctionId": auction_id_str,
            "title": title,
            "icon": icon,
            "category": category,
            "categoryColor": category_color,
            "qty": qty,
            "sellerName": l_data.get("contact_name") or "Solar Scrap Admin",
            "sellerCompany": l_data.get("pickup_area") or "Solar Scrap HQ",
            "sellerCity": l_data.get("pickup_city") or "Karachi",
            "startingPrice": int(starting_price),
            "priceDemand": int(price_demand),
            "startingBid": int(starting_bid),
            "currentHighBid": int(current_high_bid),
            "highestBidderName": highest_bidder_name,
            "highestBidderCompany": highest_bidder_company,
            "highestBidderCity": highest_bidder_city,
            "highestBidderPhone": highest_bidder_phone,
            "highestBidderEmail": highest_bidder_email,
            "totalBids": total_bids,
            "status": ui_status,
            "createdAt": _format_dt(l_data.get("created_at")) or "Recent",
            "endsIn": ends_in,
            "endDate": end_date,
            "reservePrice": int(reserve_price),
            "images": image_urls,
            "bids": formatted_bids,
            "specs": specs,
        })

    results.sort(key=lambda x: x["createdAt"], reverse=True)
    return results


@router.get("/auctions/{auction_id}")
async def get_admin_auction_detail(
    auction_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch a single auction by its auctionId (e.g. AUC001) or Firestore listing ID.
    """
    db = get_firestore_db()
    all_auctions = await get_admin_auctions(current_user=current_user)

    clean = auction_id.strip()
    clean_norm = clean.replace("-", "").upper()

    for auc in all_auctions:
        auc_id = str(auc.get("auctionId", ""))
        lid = str(auc.get("id", ""))
        if (
            lid == clean
            or auc_id.upper() == clean.upper()
            or auc_id.replace("-", "").upper() == clean_norm
        ):
            return auc

    # Fallback to direct listing doc lookup if not found in list
    doc = db.collection("listings").document(clean).get()
    if doc.exists:
        l_data = doc.to_dict() or {}
        price_demand = float(l_data.get("price_demand", 0.0))
        starting_price = float(
            l_data.get("starting_price")
            or l_data.get("starting_bid")
            or (price_demand * 0.85 if price_demand > 0 else 100000)
        )
        status_val = str(l_data.get("status", "active")).lower()
        post_status_val = str(l_data.get("post_status", "")).lower()
        if (
            status_val in ("active", "approved", "auction", "live")
            or post_status_val in ("auction", "active", "approved", "live")
            or l_data.get("is_auction") is True
        ):
            ui_status = "Active"
        elif status_val in ("closed", "sold") or post_status_val in ("closed", "sold"):
            ui_status = "Closed"
        else:
            ui_status = "Draft"

        ends_in = l_data.get("ends_in") or l_data.get("duration") or "3d 12h"
        end_date = l_data.get("end_date") or "Live"

        return {
            "id": doc.id,
            "auctionId": clean,
            "title": l_data.get("title", "Solar Equipment"),
            "icon": "☀️",
            "category": l_data.get("category", "Solar Equipment"),
            "categoryColor": "bg-blue-50 text-blue-700 border-blue-200",
            "qty": l_data.get("qty", "1 Lot"),
            "sellerName": l_data.get("contact_name") or "Solar Scrap Admin",
            "sellerCompany": l_data.get("pickup_area") or "Solar Scrap HQ",
            "sellerCity": l_data.get("pickup_city") or "Karachi",
            "startingPrice": int(starting_price),
            "priceDemand": int(price_demand),
            "startingBid": int(starting_price),
            "currentHighBid": int(l_data.get("current_high_bid", 0)),
            "highestBidderName": l_data.get("highest_bidder_name") or "No Bids Yet",
            "highestBidderCompany": l_data.get("highest_bidder_company") or "Pending Verification",
            "highestBidderCity": l_data.get("highest_bidder_city") or "Karachi",
            "highestBidderPhone": "",
            "highestBidderEmail": "",
            "totalBids": int(l_data.get("total_bids", 0)),
            "status": ui_status,
            "createdAt": _format_dt(l_data.get("created_at")) or "Recent",
            "endsIn": ends_in,
            "endDate": end_date,
            "reservePrice": int(l_data.get("reserve_price", starting_price)),
            "images": l_data.get("image_urls") or ["/images/solar-panel.png"],
            "bids": [],
            "specs": l_data.get("specs", {}),
        }

    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Auction '{auction_id}' not found",
    )


@router.post("/auctions")
async def create_admin_auction(
    payload: CreateAdminAuctionRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Create a live auction directly from the Admin Portal.
    Bypasses seller post review/verification and goes directly live to marketplace auctions.
    """
    db = get_firestore_db()
    listing_ref = db.collection("listings").document()
    auction_code = f"AUC-{listing_ref.id[:6].upper()}"

    start_price = float(payload.starting_price or payload.starting_bid or payload.price_demand or 0.0)
    demand_price = float(payload.price_demand or start_price)
    reserve_price = float(payload.reserve_price or start_price)

    display_title = payload.title
    if not display_title:
        specs = payload.specs or {}
        category = payload.category
        if specs.get("is_combined"):
            display_title = f"Combined Solar Auction ({specs.get('total_lots', 1)} Lots)"
        elif category == "Solar Panels" and "panels_count" in specs:
            display_title = f"{specs.get('panels_count')}x Solar Panels {specs.get('watts_per_panel', '')}W"
        elif category == "Batteries" and "battery_count" in specs:
            display_title = f"{specs.get('battery_count')}x {specs.get('battery_type', '')} Batteries"
        elif category == "Inverters" and "inverter_brand" in specs:
            display_title = f"{specs.get('inverter_brand', '')} Inverter"
        else:
            display_title = f"{category} Auction"

    auction_data = {
        "title": display_title,
        "category": payload.category,
        "is_auction": True,
        "status": "auction",
        "post_status": "Auction",
        "auction_id": auction_code,
        "price_demand": demand_price,
        "starting_price": start_price,
        "starting_bid": start_price,
        "reserve_price": reserve_price,
        "duration": payload.duration or "3 Days",
        "ends_in": payload.ends_in or "3d 00h",
        "specs": payload.specs,
        "image_urls": payload.image_urls,
        "pickup_city": payload.pickup_city or "Karachi",
        "pickup_area": payload.pickup_area or "Industrial Area",
        "pickup_address": payload.pickup_address or f"{payload.pickup_city or 'Karachi'}, Pakistan",
        "contact_name": payload.contact_name or "Solar Scrap Admin",
        "contact_phone": payload.contact_phone or "+92 300 1234567",
        "contact_email": payload.contact_email or "admin@solarscrap.com",
        "seller_id": current_user.user_id if current_user else "admin_system",
        "created_by": "admin",
        "created_by_admin": True,
        "created_at": firestore.SERVER_TIMESTAMP,
        "updated_at": firestore.SERVER_TIMESTAMP,
    }

    listing_ref.set(auction_data)

    create_admin_notification(
        db=db,
        notif_type="auction_created",
        title="Auction Published Live!",
        description=f"'{display_title}' is now live for dealer bidding.",
        entity_id=listing_ref.id,
        entity_type="auction",
    )

    return {
        "id": listing_ref.id,
        "auction_id": auction_code,
        "title": display_title,
        "status": "Active",
        "starting_price": start_price,
        "ends_in": payload.ends_in or "3d 00h",
        "message": "Auction created and published live successfully",
    }


@router.post("/auctions/{listing_id}/close")
async def close_admin_auction(
    listing_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Close an auction directly from the admin portal.
    """
    db = get_firestore_db()
    listing_ref = db.collection("listings").document(listing_id)
    listing_doc = listing_ref.get()
    if not listing_doc.exists:
        raise HTTPException(status_code=404, detail="Listing not found")

    listing_ref.update({
        "status": "closed",
        "updated_at": firestore.SERVER_TIMESTAMP,
    })
    return {"message": "Auction closed successfully", "id": listing_id}


@router.post("/bids/{bid_id}/accept")
async def accept_admin_bid(
    bid_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Accept a bid as the winning bid directly from the admin portal.
    """
    db = get_firestore_db()
    bid_ref = db.collection("bids").document(bid_id)
    bid_doc = bid_ref.get()
    if not bid_doc.exists:
        raise HTTPException(status_code=404, detail="Bid not found")

    bid_data = bid_doc.to_dict() or {}
    listing_id = bid_data.get("listing_id")
    buyer_id = bid_data.get("buyer_id")
    amount = bid_data.get("amount", 0)
    title = bid_data.get("listing_title", "Solar Scrap Listing")

    bid_ref.update({
        "status": "accepted",
        "updated_at": firestore.SERVER_TIMESTAMP,
    })

    if listing_id:
        db.collection("listings").document(listing_id).update({
            "status": "closed",
            "winning_bid_id": bid_id,
            "winning_bid_amount": amount,
            "winning_buyer_id": buyer_id,
            "updated_at": firestore.SERVER_TIMESTAMP,
        })

    if buyer_id:
        create_user_notification(
            db=db,
            user_id=buyer_id,
            notif_type="bid_won",
            title="Auction Won!",
            description=f"Congratulations! Your bid of PKR {int(amount):,} on {title} was accepted by the admin.",
            listing_id=listing_id,
        )

    return {"message": "Bid accepted as winner successfully", "bid_id": bid_id}


@router.get("/bids")
async def get_admin_bids(
    auction_id: Optional[str] = Query(None, description="Optional auction ID or listing ID filter e.g. AUC001"),
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch bids across all auctions or filtered for a specific auctionId/listing_id.
    """
    db = get_firestore_db()
    listings_docs = list(db.collection("listings").stream())
    def _doc_sort_key(doc):
        dt = (doc.to_dict() or {}).get("created_at")
        if not dt:
            return ""
        if hasattr(dt, "isoformat"):
            return dt.isoformat()
        return str(dt)
    listings_docs.sort(key=_doc_sort_key, reverse=True)

    # Build mapping from listing IDs to auction display ID and titles
    listing_id_to_auc_id = {}
    listing_id_to_title = {}
    matched_listing_ids = set()

    clean_filter = auction_id.strip() if auction_id else None
    clean_filter_normalized = clean_filter.replace("-", "").upper() if clean_filter else None

    for idx, doc in enumerate(listings_docs):
        lid = doc.id
        l_data = doc.to_dict() or {}
        specs = l_data.get("specs", {}) or {}
        category = l_data.get("category", "Solar Equipment")

        # Dynamic title
        title = l_data.get("title")
        if not title:
            if category == "Solar Panels" and "panels_count" in specs:
                title = f"{specs.get('panels_count')}x Solar Panels {specs.get('watts_per_panel', '')}W"
            elif category == "Inverters" and ("inverter_brand" in specs or "brand" in specs):
                brand = specs.get("inverter_brand") or specs.get("brand", "")
                power = specs.get("rated_power", "")
                title = f"{power} {brand}".strip() or "Solar Inverter"
            elif category == "Batteries" and ("battery_count" in specs or "count" in specs):
                count = specs.get("battery_count") or specs.get("count", "")
                b_type = specs.get("battery_type") or specs.get("type", "")
                title = f"{count}x {b_type} Batteries".strip()
            elif category == "Cables":
                title = f"Solar DC/AC Cables {specs.get('size', '')}".strip() or "Solar Cables"
            elif category == "Structure":
                title = f"{specs.get('structure_type', '')} Solar Mounting Structure".strip() or "Solar Structure"
            else:
                title = f"{category} Lot"

        custom_auc = l_data.get("auction_id")
        if custom_auc and not str(custom_auc).upper().startswith("AUC-LISTIN"):
            auc_id_str = custom_auc
        else:
            auc_id_str = f"AUC{idx + 1:03d}"

        listing_id_to_auc_id[lid] = auc_id_str
        listing_id_to_title[lid] = title

        if clean_filter:
            if (
                lid == clean_filter
                or (custom_auc and str(custom_auc).upper() == clean_filter.upper())
                or auc_id_str.upper() == clean_filter.upper()
                or auc_id_str.replace("-", "").upper() == clean_filter_normalized
            ):
                matched_listing_ids.add(lid)

    # If clean_filter was passed but didn't match any computed auction ID, also try as direct listing_id
    if clean_filter and not matched_listing_ids:
        matched_listing_ids.add(clean_filter)

    # Fetch bids from Firestore strictly by listing_id
    if clean_filter and matched_listing_ids:
        bids_docs = []
        for mlid in matched_listing_ids:
            docs = list(db.collection("bids").where("listing_id", "==", mlid).stream())
            bids_docs.extend(docs)
    elif clean_filter and not matched_listing_ids:
        bids_docs = list(db.collection("bids").where("listing_id", "==", clean_filter).stream())
    else:
        bids_docs = list(db.collection("bids").stream())

    results = []
    for b in bids_docs:
        bd = b.to_dict() or {}
        bd["id"] = b.id
        status_raw = str(bd.get("status", "pending")).lower()
        if status_raw in ("accepted", "winner"):
            ui_status = "Winner"
        elif status_raw in ("rejected", "lost", "outbid"):
            ui_status = "Lost"
        else:
            ui_status = "Pending"

        lid_val = bd.get("listing_id") or ""
        resolved_auc_id = listing_id_to_auc_id.get(lid_val) or bd.get("auction_id") or bd.get("auctionId") or (clean_filter or "AUC001")
        if "LISTIN" in str(resolved_auc_id).upper():
            resolved_auc_id = listing_id_to_auc_id.get(lid_val, clean_filter or "AUC001")

        results.append({
            "id": b.id,
            "bidderName": bd.get("buyer_name") or "Verified Buyer",
            "bidderAvatar": bd.get("buyer_avatar") or None,
            "bidderCity": bd.get("buyer_city") or "Karachi",
            "bidderCompany": bd.get("buyer_company") or "Scrap Trading Co.",
            "bidderEmail": bd.get("buyer_email") or "",
            "bidderPhone": bd.get("buyer_phone") or "",
            "bidAmount": float(bd.get("amount", 0.0)),
            "auctionId": resolved_auc_id,
            "listingId": lid_val,
            "equipment": bd.get("listing_title") or listing_id_to_title.get(lid_val) or bd.get("listing_category") or "Solar Equipment",
            "submittedDate": bd.get("submitted_date") or _format_dt(bd.get("created_at")) or "Recent",
            "status": ui_status,
            "isHighest": False,
        })

    # Sort descending by bidAmount
    results.sort(key=lambda x: x["bidAmount"], reverse=True)
    if results and results[0]["bidAmount"] > 0:
        top_amt = results[0]["bidAmount"]
        for r in results:
            if r["bidAmount"] == top_amt:
                r["isHighest"] = True
            else:
                break

    return results


@router.get("/notifications")
async def get_admin_notifications(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all admin notifications, newest first.
    """
    db = get_firestore_db()
    try:
        docs = (
            db.collection("admin_notifications")
            .order_by("created_at", direction=firestore.Query.DESCENDING)
            .limit(100)
            .stream()
        )
        results = []
        for doc in docs:
            data = doc.to_dict() or {}
            results.append({
                "id": doc.id,
                "type": data.get("type", "general"),
                "title": data.get("title", ""),
                "description": data.get("description", ""),
                "entity_id": data.get("entity_id"),
                "entity_type": data.get("entity_type"),
                "is_read": bool(data.get("is_read", False)),
                "created_at": _format_dt(data.get("created_at")),
            })
        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch admin notifications: {str(e)}",
        )


@router.post("/notifications/{notification_id}/read")
async def mark_admin_notification_read(
    notification_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Mark a single admin notification as read.
    """
    db = get_firestore_db()
    try:
        notif_ref = db.collection("admin_notifications").document(notification_id)
        notif_ref.update({"is_read": True})
        return {"success": True, "message": "Notification marked as read"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update notification: {str(e)}",
        )


@router.post("/notifications/read-all")
async def mark_all_admin_notifications_read(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Mark all admin notifications as read.
    """
    db = get_firestore_db()
    try:
        docs = db.collection("admin_notifications").where("is_read", "==", False).stream()
        batch = db.batch()
        count = 0
        for doc in docs:
            batch.update(doc.reference, {"is_read": True})
            count += 1
            if count >= 450:
                batch.commit()
                batch = db.batch()
                count = 0
        if count > 0:
            batch.commit()
        return {"success": True, "message": "All notifications marked as read"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to mark all as read: {str(e)}",
        )


@router.delete("/notifications/{notification_id}")
async def delete_admin_notification(
    notification_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Delete a single admin notification.
    """
    db = get_firestore_db()
    try:
        db.collection("admin_notifications").document(notification_id).delete()
        return {"success": True, "message": "Notification deleted"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to delete notification: {str(e)}",
        )




