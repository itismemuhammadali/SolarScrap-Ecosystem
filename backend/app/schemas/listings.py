from enum import Enum
from typing import Optional, Dict, Any, List
from pydantic import BaseModel, Field
from datetime import datetime


class ListingStatus(str, Enum):
    ACTIVE = "active"
    UNDER_REVIEW = "under_review"
    SOLD = "sold"
    CLOSED = "closed"


class CreateListingRequest(BaseModel):
    category: str = Field(..., description="Category: Solar Panels, Batteries, Inverters, Cables, Structure, Complete Solar System")
    price_demand: float = Field(..., description="Price demand in PKR")
    specs: Dict[str, Any] = Field(default_factory=dict, description="Category-specific equipment specifications")
    image_urls: List[str] = Field(default_factory=list, description="Uploaded image URLs or paths")
    pickup_city: str = Field(..., description="Pickup City")
    pickup_area: Optional[str] = Field(None, description="Pickup Area/Locality")
    pickup_address: str = Field(..., description="Complete Pickup Address")
    contact_name: str = Field(..., description="Seller/Contact Person Name")
    contact_phone: str = Field(..., description="Contact Phone Number")
    contact_email: str = Field(..., description="Contact Email Address")
    latitude: Optional[float] = Field(None, description="Pickup GPS Latitude")
    longitude: Optional[float] = Field(None, description="Pickup GPS Longitude")
    title: Optional[str] = None
    is_auction: Optional[bool] = None
    status: Optional[str] = None
    post_status: Optional[str] = None
    starting_price: Optional[float] = None
    starting_bid: Optional[float] = None
    reserve_price: Optional[float] = None
    duration: Optional[str] = None
    ends_in: Optional[str] = None
    auction_id: Optional[str] = None


class ListingResponse(BaseModel):
    id: str
    seller_id: str
    category: str
    status: str = "active"
    price_demand: float
    specs: Dict[str, Any] = Field(default_factory=dict)
    image_urls: List[str] = Field(default_factory=list)
    pickup_city: str
    pickup_area: Optional[str] = None
    pickup_address: str
    contact_name: str
    contact_phone: str
    contact_email: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    created_at: Optional[str] = None
    updated_at: Optional[str] = None
