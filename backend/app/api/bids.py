import uuid
from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends, status
from firebase_admin import firestore
from app.schemas.auth import UserProfile
from app.schemas.bids import PlaceBidRequest, BidResponse, UpdateBidStatusRequest
from app.api.auth import get_current_user
from app.api.notifications import create_user_notification
from app.core.firebase import get_firestore_db

router = APIRouter(prefix="/bids", tags=["Bids"])


def _format_datetime(dt):
    if dt is None:
        return None
    if hasattr(dt, "isoformat"):
        return dt.isoformat()
    return str(dt)


def _get_listing_title(category: str, specs: dict) -> str:
    if category == "Solar Panels" and "panels_count" in specs:
        return f"{specs.get('panels_count')}x Solar Panels {specs.get('watts_per_panel', '')}W"
    elif category == "Batteries" and "battery_count" in specs:
        return f"{specs.get('battery_count')}x {specs.get('battery_type', '')} Batteries"
    elif category == "Inverters" and "inverter_brand" in specs:
        return f"{specs.get('inverter_brand', '')} Inverter"
    return category or "Solar Equipment"


@router.post("", response_model=BidResponse, status_code=status.HTTP_201_CREATED)
async def place_bid(
    payload: PlaceBidRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Submit a new bid on an active listing.
    Notifies the seller and records the bid in Firestore.
    """
    db = get_firestore_db()

    # 1. Fetch listing to get seller and title
    listing_ref = db.collection("listings").document(payload.listing_id)
    listing_doc = listing_ref.get()

    if not listing_doc.exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Listing not found",
        )

    listing_data = listing_doc.to_dict() or {}
    seller_id = listing_data.get("seller_id", "")
    category = listing_data.get("category", "")
    specs = listing_data.get("specs", {})
    image_urls = listing_data.get("image_urls", [])
    first_image = image_urls[0] if image_urls else None
    display_title = _get_listing_title(category, specs)

    # 2. Check if buyer has an existing bid for this listing
    existing_bids = (
        db.collection("bids")
        .where("listing_id", "==", payload.listing_id)
        .where("buyer_id", "==", current_user.user_id)
        .stream()
    )
    existing_bid_doc = None
    for b in existing_bids:
        existing_bid_doc = b
        break

    ref_id = f"BID-{str(uuid.uuid4())[:6].upper()}"

    if existing_bid_doc:
        bid_ref = db.collection("bids").document(existing_bid_doc.id)
        bid_data = {
            "amount": float(payload.amount),
            "status": "pending",
            "updated_at": firestore.SERVER_TIMESTAMP,
        }
        bid_ref.update(bid_data)
        bid_id = existing_bid_doc.id
        doc_data = existing_bid_doc.to_dict() or {}
        ref_id = doc_data.get("reference_number", ref_id)
    else:
        bid_ref = db.collection("bids").document()
        bid_id = bid_ref.id
        bid_data = {
            "listing_id": payload.listing_id,
            "seller_id": seller_id,
            "buyer_id": current_user.user_id,
            "buyer_name": current_user.full_name or "Verified Buyer",
            "amount": float(payload.amount),
            "status": "pending",
            "reference_number": ref_id,
            "listing_title": display_title,
            "listing_category": category,
            "listing_image": first_image,
            "created_at": firestore.SERVER_TIMESTAMP,
            "updated_at": firestore.SERVER_TIMESTAMP,
        }
        bid_ref.set(bid_data)

    # 3. Create notification for seller
    if seller_id:
        create_user_notification(
            db=db,
            user_id=seller_id,
            notif_type="new_bid_received",
            title="New Bid Received!",
            description=f"A buyer placed a bid of PKR {int(payload.amount):,} on your {display_title}.",
            listing_id=payload.listing_id,
        )

    # 4. Create confirmation notification for buyer
    create_user_notification(
        db=db,
        user_id=current_user.user_id,
        notif_type="bid_confirmed",
        title="Bid Submitted!",
        description=f"Your bid of PKR {int(payload.amount):,} on {display_title} has been submitted.",
        listing_id=payload.listing_id,
    )

    return BidResponse(
        id=bid_id,
        listing_id=payload.listing_id,
        seller_id=seller_id,
        buyer_id=current_user.user_id,
        buyer_name=current_user.full_name or "Verified Buyer",
        amount=float(payload.amount),
        status="pending",
        reference_number=ref_id,
        listing_title=display_title,
        listing_category=category,
        listing_image=first_image,
        created_at=_format_datetime(bid_data.get("created_at")),
        updated_at=_format_datetime(bid_data.get("updated_at")),
    )


@router.get("", response_model=List[BidResponse])
async def get_my_bids(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all bids placed by the currently logged-in buyer.
    """
    db = get_firestore_db()
    try:
        bids_query = (
            db.collection("bids")
            .where("buyer_id", "==", current_user.user_id)
            .stream()
        )

        results = []
        for doc in bids_query:
            data = doc.to_dict() or {}
            results.append(
                BidResponse(
                    id=doc.id,
                    listing_id=data.get("listing_id", ""),
                    seller_id=data.get("seller_id", ""),
                    buyer_id=data.get("buyer_id", current_user.user_id),
                    buyer_name=data.get("buyer_name", "Buyer"),
                    amount=float(data.get("amount", 0.0)),
                    status=data.get("status", "pending"),
                    reference_number=data.get("reference_number", f"BID-{doc.id[:6].upper()}"),
                    listing_title=data.get("listing_title", "Solar Equipment"),
                    listing_category=data.get("listing_category", ""),
                    listing_image=data.get("listing_image"),
                    created_at=_format_datetime(data.get("created_at")),
                    updated_at=_format_datetime(data.get("updated_at")),
                )
            )

        # Sort newest first
        results.sort(key=lambda x: x.created_at or "", reverse=True)
        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch bids: {str(e)}",
        )


@router.get("/listing/{listing_id}", response_model=List[BidResponse])
async def get_bids_for_listing(
    listing_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all bids placed on a specific listing (for the seller or buyer).
    """
    db = get_firestore_db()
    try:
        bids_query = (
            db.collection("bids")
            .where("listing_id", "==", listing_id)
            .stream()
        )

        results = []
        for doc in bids_query:
            data = doc.to_dict() or {}
            results.append(
                BidResponse(
                    id=doc.id,
                    listing_id=data.get("listing_id", listing_id),
                    seller_id=data.get("seller_id", ""),
                    buyer_id=data.get("buyer_id", ""),
                    buyer_name=data.get("buyer_name", "Buyer"),
                    amount=float(data.get("amount", 0.0)),
                    status=data.get("status", "pending"),
                    reference_number=data.get("reference_number", f"BID-{doc.id[:6].upper()}"),
                    listing_title=data.get("listing_title", "Solar Equipment"),
                    listing_category=data.get("listing_category", ""),
                    listing_image=data.get("listing_image"),
                    created_at=_format_datetime(data.get("created_at")),
                    updated_at=_format_datetime(data.get("updated_at")),
                )
            )

        # Sort highest bid first
        results.sort(key=lambda x: x.amount, reverse=True)
        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch bids for listing: {str(e)}",
        )


@router.post("/{bid_id}/accept", response_model=BidResponse)
async def accept_bid(
    bid_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Accept a specific bid on a listing.
    Marks bid as accepted, marks listing as sold/closed, notifies buyer and seller.
    """
    db = get_firestore_db()
    bid_ref = db.collection("bids").document(bid_id)
    bid_doc = bid_ref.get()

    if not bid_doc.exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Bid not found",
        )

    bid_data = bid_doc.to_dict() or {}
    listing_id = bid_data.get("listing_id", "")
    buyer_id = bid_data.get("buyer_id", "")
    amount = float(bid_data.get("amount", 0.0))
    title = bid_data.get("listing_title", "Solar Equipment")

    # Update bid status to accepted
    bid_ref.update({
        "status": "accepted",
        "updated_at": firestore.SERVER_TIMESTAMP,
    })

    # Update listing status to closed / deal_closed
    if listing_id:
        listing_ref = db.collection("listings").document(listing_id)
        listing_ref.update({
            "status": "closed",
            "updated_at": firestore.SERVER_TIMESTAMP,
        })

    # Notify buyer
    if buyer_id:
        create_user_notification(
            db=db,
            user_id=buyer_id,
            notif_type="bid_won",
            title="Bid Accepted!",
            description=f"Congratulations! Your bid of PKR {int(amount):,} on {title} has been accepted.",
            listing_id=listing_id,
        )

    # Notify seller
    create_user_notification(
        db=db,
        user_id=current_user.user_id,
        notif_type="deal_closed",
        title="Deal Closed!",
        description=f"You accepted the bid of PKR {int(amount):,} on {title}.",
        listing_id=listing_id,
    )

    doc = bid_ref.get()
    updated = doc.to_dict() or {}

    return BidResponse(
        id=bid_id,
        listing_id=listing_id,
        seller_id=updated.get("seller_id", current_user.user_id),
        buyer_id=buyer_id,
        buyer_name=updated.get("buyer_name", "Buyer"),
        amount=amount,
        status="accepted",
        reference_number=updated.get("reference_number", f"BID-{bid_id[:6].upper()}"),
        listing_title=title,
        listing_category=updated.get("listing_category", ""),
        listing_image=updated.get("listing_image"),
        created_at=_format_datetime(updated.get("created_at")),
        updated_at=_format_datetime(updated.get("updated_at")),
    )


@router.post("/{bid_id}/reject", response_model=BidResponse)
async def reject_bid(
    bid_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Reject a specific bid on a listing.
    Marks bid as rejected, notifies buyer.
    """
    db = get_firestore_db()
    bid_ref = db.collection("bids").document(bid_id)
    bid_doc = bid_ref.get()

    if not bid_doc.exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Bid not found",
        )

    bid_data = bid_doc.to_dict() or {}
    listing_id = bid_data.get("listing_id", "")
    buyer_id = bid_data.get("buyer_id", "")
    amount = float(bid_data.get("amount", 0.0))
    title = bid_data.get("listing_title", "Solar Equipment")

    bid_ref.update({
        "status": "rejected",
        "updated_at": firestore.SERVER_TIMESTAMP,
    })

    if buyer_id:
        create_user_notification(
            db=db,
            user_id=buyer_id,
            notif_type="bid_lost",
            title="Bid Declined",
            description=f"Your bid of PKR {int(amount):,} on {title} was declined.",
            listing_id=listing_id,
        )

    doc = bid_ref.get()
    updated = doc.to_dict() or {}

    return BidResponse(
        id=bid_id,
        listing_id=listing_id,
        seller_id=updated.get("seller_id", ""),
        buyer_id=buyer_id,
        buyer_name=updated.get("buyer_name", "Buyer"),
        amount=amount,
        status="rejected",
        reference_number=updated.get("reference_number", f"BID-{bid_id[:6].upper()}"),
        listing_title=title,
        listing_category=updated.get("listing_category", ""),
        listing_image=updated.get("listing_image"),
        created_at=_format_datetime(updated.get("created_at")),
        updated_at=_format_datetime(updated.get("updated_at")),
    )
