from enum import Enum
from typing import Optional
from pydantic import BaseModel, EmailStr, Field


class UserRole(str, Enum):
    BUYER = "buyer"
    SELLER = "seller"
    ADMIN = "admin"


class LoginRequest(BaseModel):
    email: str = Field(..., description="User email or phone")
    password: str = Field(..., min_length=6, description="User password")
    role: UserRole = Field(..., description="Expected role: buyer or seller")


class UserProfile(BaseModel):
    user_id: str
    email: str
    role: UserRole
    display_name: Optional[str] = None
    phone_number: Optional[str] = None
    company_name: Optional[str] = None
    city: Optional[str] = None
    area: Optional[str] = None
    address: Optional[str] = None
    company_type: Optional[str] = None
    gst_number: Optional[str] = None
    profile_photo_url: Optional[str] = None
    created_at: Optional[str] = None


class UpdateProfileRequest(BaseModel):
    display_name: Optional[str] = None
    phone_number: Optional[str] = None
    company_name: Optional[str] = None
    city: Optional[str] = None
    area: Optional[str] = None
    address: Optional[str] = None
    company_type: Optional[str] = None
    gst_number: Optional[str] = None
    profile_photo_url: Optional[str] = None


class SellerStatsResponse(BaseModel):
    listings_count: int = 0
    deals_count: int = 0
    total_earnings: str = "Rs. 0"


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserProfile
    message: str = "Login successful"


class ErrorResponse(BaseModel):
    detail: str


class RegisterRequest(BaseModel):
    email: str = Field(..., description="User email")
    password: str = Field(..., min_length=6, description="User password")
    role: UserRole = Field(..., description="Expected role: buyer or seller")
    full_name: str = Field(..., description="Full name of user")
    phone_number: str = Field(..., description="Phone number")
    company_name: str = Field(..., description="Company name")
    city: str = Field(..., description="City")
    area: str = Field(..., description="Area")
    address: str = Field(..., description="Complete address")
    company_type: Optional[str] = Field(None, description="Company type")
    gst_number: Optional[str] = Field(None, description="GST number")


class RegisterResponse(LoginResponse):
    masked_phone: str = Field(..., description="Masked phone number for OTP UI")

