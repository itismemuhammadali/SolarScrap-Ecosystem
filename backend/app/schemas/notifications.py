from typing import Optional
from pydantic import BaseModel, Field


class CreateNotificationRequest(BaseModel):
    type: str = Field(..., description="Notification type: listing_created, listing_under_review, price_offered, deal_closed, profile_verified")
    title: str = Field(..., description="Notification Title")
    description: str = Field(..., description="Notification detail message")
    listing_id: Optional[str] = Field(None, description="Optional associated listing ID")


class NotificationResponse(BaseModel):
    id: str
    user_id: str
    type: str
    title: str
    description: str
    listing_id: Optional[str] = None
    is_read: bool = False
    created_at: Optional[str] = None
