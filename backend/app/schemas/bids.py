from enum import Enum
from typing import Optional
from pydantic import BaseModel, Field


class BidStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    OUTBID = "outbid"
    CLOSED = "closed"


class PlaceBidRequest(BaseModel):
    listing_id: str = Field(..., description="The ID of the listing being bid on")
    amount: float = Field(..., description="The bid amount in PKR")


class UpdateBidStatusRequest(BaseModel):
    status: BidStatus = Field(..., description="New status for the bid: accepted, rejected")


class BidResponse(BaseModel):
    id: str
    listing_id: str
    seller_id: str
    buyer_id: str
    buyer_name: str
    amount: float
    status: str = "pending"
    reference_number: str
    listing_title: Optional[str] = None
    listing_category: Optional[str] = None
    listing_image: Optional[str] = None
    created_at: Optional[str] = None
    updated_at: Optional[str] = None
