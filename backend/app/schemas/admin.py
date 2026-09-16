from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field


class StatCardItem(BaseModel):
    total_sellers: int = 0
    total_dealers: int = 0
    pending_approvals: int = 0
    pending_posts: int = 0
    active_auctions: int = 0
    total_bids: int = 0
    facebook_leads: int = 0


class UserGrowthPoint(BaseModel):
    month: str
    sellers: int
    dealers: int


class UserStatusBreakdown(BaseModel):
    approved: int = 0
    pending: int = 0
    rejected: int = 0


class BidActivityWeek(BaseModel):
    week: str
    count: int
    height_pct: int


class CityLeadItem(BaseModel):
    city: str
    count: int
    percentage: int


class RecentActivityItem(BaseModel):
    id: str
    title: str
    time: str
    type: str  # "user" | "bid" | "post" | "auction" | "lead"


class DashboardStatsResponse(BaseModel):
    stats: StatCardItem
    user_growth: List[UserGrowthPoint]
    user_status: UserStatusBreakdown
    bid_activity: List[BidActivityWeek]
    city_leads: List[CityLeadItem]
    recent_activities: List[RecentActivityItem]


class AdminUserItem(BaseModel):
    id: str
    name: str
    avatar_letter: str
    company: str
    email: str
    phone: str
    status: str  # "Pending" | "Approved" | "Rejected"
    activity_status: str  # "Active" | "Inactive"
    joined: str
    role: str
    city: str
    area: str
    profile_photo_url: Optional[str] = None


class UpdateUserStatusRequest(BaseModel):
    status: str = Field(..., description="'approved' | 'rejected' | 'pending'")


class AdminLeadItem(BaseModel):
    id: str
    lead_id: str
    name: str
    phone: str
    email: str
    city: str
    area: str
    received_date: str
    status: str  # "New" | "Contacted" | "Follow-up" | "Converted"
    source: str
    notes: List[str] = []


class UpdateLeadRequest(BaseModel):
    status: Optional[str] = None
    note: Optional[str] = None


class AdminSellerPostItem(BaseModel):
    id: str
    post_id: str
    title: str
    category: str
    qty: int
    condition: str
    status: str
    price_expected: float
    offered_price: Optional[float] = None
    submitted_date: str
    seller_name: str
    seller_company: str
    seller_email: str
    seller_phone: str
    city: str
    area: str
    address: str
    brand_model: str
    estimated_weight: str
    disassembly_state: str
    images: List[str] = []
    watts_per_unit: Optional[str] = None
    manufacturer: Optional[str] = None
    purchase_year: Optional[str] = None
    reason_for_sale: Optional[str] = None
    admin_notes: Optional[str] = None


class UpdateSellerPostRequest(BaseModel):
    status: Optional[str] = None
    offered_price: Optional[float] = None
    admin_notes: Optional[str] = None
    starting_price: Optional[float] = None
    duration: Optional[str] = None
    ends_in: Optional[str] = None


class CreateAdminAuctionRequest(BaseModel):
    title: Optional[str] = None
    category: str = Field(..., description="Category: Solar Panels, Batteries, Inverters, Cables, Structure, Complete Solar System")
    price_demand: float = Field(default=0.0)
    starting_price: Optional[float] = None
    starting_bid: Optional[float] = None
    reserve_price: Optional[float] = None
    duration: Optional[str] = "3 Days"
    ends_in: Optional[str] = "3d 00h"
    specs: Dict[str, Any] = Field(default_factory=dict)
    image_urls: List[str] = Field(default_factory=list)
    pickup_city: str = "Karachi"
    pickup_area: Optional[str] = None
    pickup_address: str = "Karachi"
    contact_name: str = "Solar Scrap Admin"
    contact_phone: str = "+92 300 1234567"
    contact_email: str = "admin@solarscrap.com"


