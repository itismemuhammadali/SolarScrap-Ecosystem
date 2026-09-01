from typing import List
from fastapi import APIRouter, HTTPException, Depends, status
from firebase_admin import firestore
from app.schemas.auth import UserProfile
from app.schemas.listings import CreateListingRequest, ListingResponse
from app.api.auth import get_current_user
from app.api.notifications import create_user_notification
from app.core.firebase import get_firestore_db

router = APIRouter(prefix="/listings", tags=["Listings"])


def _format_datetime(dt):
    if dt is None:
        return None
    if hasattr(dt, "isoformat"):
        return dt.isoformat()
    return str(dt)


@router.post("", response_model=ListingResponse, status_code=status.HTTP_201_CREATED)
async def create_listing(
    payload: CreateListingRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Create a new listing in Firestore.
    Listing is automatically marked as 'active' (auto-approved).
    """
    db = get_firestore_db()
    listing_ref = db.collection("listings").document()

    listing_data = {
        "seller_id": current_user.user_id,
        "category": payload.category,
        "status": "active",  # Auto-approved
        "price_demand": payload.price_demand,
        "specs": payload.specs,
        "image_urls": payload.image_urls,
        "pickup_city": payload.pickup_city,
        "pickup_area": payload.pickup_area,
        "pickup_address": payload.pickup_address,
        "contact_name": payload.contact_name,
        "contact_phone": payload.contact_phone,
        "contact_email": payload.contact_email,
        "created_at": firestore.SERVER_TIMESTAMP,
        "updated_at": firestore.SERVER_TIMESTAMP,
    }

    try:
        listing_ref.set(listing_data)
        doc = listing_ref.get()
        data = doc.to_dict() or {}

        # Create in-app notification for listing creation
        display_title = payload.category
        if payload.category == "Solar Panels" and "panels_count" in payload.specs:
            display_title = f"{payload.specs.get('panels_count')}x Solar Panels {payload.specs.get('watts_per_panel', '')}W"
        elif payload.category == "Batteries" and "battery_count" in payload.specs:
            display_title = f"{payload.specs.get('battery_count')}x {payload.specs.get('battery_type', '')} Batteries"
        elif payload.category == "Inverters" and "inverter_brand" in payload.specs:
            display_title = f"{payload.specs.get('inverter_brand', '')} Inverter"

        create_user_notification(
            db=db,
            user_id=current_user.user_id,
            notif_type="listing_created",
            title="Listing Created & Live!",
            description=f"Your {display_title} listing has been created and is active on the marketplace.",
            listing_id=listing_ref.id,
        )
        
        return ListingResponse(
            id=listing_ref.id,
            seller_id=current_user.user_id,
            category=data.get("category", payload.category),
            status=data.get("status", "active"),
            price_demand=data.get("price_demand", payload.price_demand),
            specs=data.get("specs", payload.specs),
            image_urls=data.get("image_urls", payload.image_urls),
            pickup_city=data.get("pickup_city", payload.pickup_city),
            pickup_area=data.get("pickup_area", payload.pickup_area),
            pickup_address=data.get("pickup_address", payload.pickup_address),
            contact_name=data.get("contact_name", payload.contact_name),
            contact_phone=data.get("contact_phone", payload.contact_phone),
            contact_email=data.get("contact_email", payload.contact_email),
            created_at=_format_datetime(data.get("created_at")),
            updated_at=_format_datetime(data.get("updated_at")),
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create listing: {str(e)}",
        )


@router.get("", response_model=List[ListingResponse])
async def get_my_listings(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Get all listings belonging to the authenticated seller.
    """
    db = get_firestore_db()
    try:
        listings_query = (
            db.collection("listings")
            .where("seller_id", "==", current_user.user_id)
            .stream()
        )

        results = []
        for doc in listings_query:
            data = doc.to_dict()
            results.append(
                ListingResponse(
                    id=doc.id,
                    seller_id=data.get("seller_id", current_user.user_id),
                    category=data.get("category", ""),
                    status=data.get("status", "active"),
                    price_demand=float(data.get("price_demand", 0.0)),
                    specs=data.get("specs", {}),
                    image_urls=data.get("image_urls", []),
                    pickup_city=data.get("pickup_city", ""),
                    pickup_area=data.get("pickup_area"),
                    pickup_address=data.get("pickup_address", ""),
                    contact_name=data.get("contact_name", ""),
                    contact_phone=data.get("contact_phone", ""),
                    contact_email=data.get("contact_email", ""),
                    created_at=_format_datetime(data.get("created_at")),
                    updated_at=_format_datetime(data.get("updated_at")),
                )
            )
        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch listings: {str(e)}",
        )


@router.get("/all", response_model=List[ListingResponse])
async def get_all_active_listings(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Get all active listings on the marketplace for buyers.
    """
    db = get_firestore_db()
    try:
        listings_query = (
            db.collection("listings")
            .where("status", "==", "active")
            .stream()
        )

        results = []
        for doc in listings_query:
            data = doc.to_dict() or {}
            results.append(
                ListingResponse(
                    id=doc.id,
                    seller_id=data.get("seller_id", ""),
                    category=data.get("category", ""),
                    status=data.get("status", "active"),
                    price_demand=float(data.get("price_demand", 0.0)),
                    specs=data.get("specs", {}),
                    image_urls=data.get("image_urls", []),
                    pickup_city=data.get("pickup_city", ""),
                    pickup_area=data.get("pickup_area"),
                    pickup_address=data.get("pickup_address", ""),
                    contact_name=data.get("contact_name", ""),
                    contact_phone=data.get("contact_phone", ""),
                    contact_email=data.get("contact_email", ""),
                    created_at=_format_datetime(data.get("created_at")),
                    updated_at=_format_datetime(data.get("updated_at")),
                )
            )
        # Sort newest first if created_at is available
        results.sort(
            key=lambda x: x.created_at or "",
            reverse=True
        )
        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch active listings: {str(e)}",
        )


@router.get("/{listing_id}", response_model=ListingResponse)
async def get_listing_by_id(
    listing_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Get a single listing by its ID.
    """
    db = get_firestore_db()
    doc_ref = db.collection("listings").document(listing_id)
    doc = doc_ref.get()

    if not doc.exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Listing not found",
        )

    data = doc.to_dict() or {}
    return ListingResponse(
        id=doc.id,
        seller_id=data.get("seller_id", ""),
        category=data.get("category", ""),
        status=data.get("status", "active"),
        price_demand=float(data.get("price_demand", 0.0)),
        specs=data.get("specs", {}),
        image_urls=data.get("image_urls", []),
        pickup_city=data.get("pickup_city", ""),
        pickup_area=data.get("pickup_area"),
        pickup_address=data.get("pickup_address", ""),
        contact_name=data.get("contact_name", ""),
        contact_phone=data.get("contact_phone", ""),
        contact_email=data.get("contact_email", ""),
        created_at=_format_datetime(data.get("created_at")),
        updated_at=_format_datetime(data.get("updated_at")),
    )
