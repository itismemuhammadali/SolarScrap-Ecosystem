from enum import Enum
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class UserRole(str, Enum):
    BUYER = "buyer"
    SELLER = "seller"
    ADMIN = "admin"


class LoginRequest(BaseModel):
    email: str = Field(..., description="User email or phone")
    password: str = Field(..., min_length=6, description="User password")
    role: Optional[UserRole] = Field(None, description="Expected role: buyer, seller, or admin (optional)")


class GoogleAuthRequest(BaseModel):
    id_token: Optional[str] = Field(None, description="Google ID Token")
    email: str = Field(..., description="Google account email")
    display_name: Optional[str] = Field(None, description="Display Name")
    photo_url: Optional[str] = Field(None, description="Profile Photo URL")
    role: UserRole = Field(..., description="Expected role: buyer or seller")
    google_id: Optional[str] = Field(None, description="Google User ID")


class AppleAuthRequest(BaseModel):
    identity_token: Optional[str] = Field(None, description="Apple Identity Token")
    user_identifier: str = Field(..., description="Apple unique user ID")
    email: Optional[str] = Field(None, description="Apple account email")
    display_name: Optional[str] = Field(None, description="Display Name")
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
    status: Optional[str] = "approved"
    email_verified: bool = False
    phone_verified: bool = False
    two_factor_enabled: bool = False
    fcm_token: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
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
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class SellerStatsResponse(BaseModel):
    listings_count: int = 0
    deals_count: int = 0
    total_earnings: str = "Rs. 0"


class BuyerStatsResponse(BaseModel):
    total_bids: int = 0
    won_auctions: int = 0
    active_bids: int = 0


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserProfile
    message: str = "Login successful"


class ErrorResponse(BaseModel):
    detail: str


class RegisterRequest(BaseModel):
    email: str = Field(..., description="User email")
    password: Optional[str] = Field(None, description="User password")
    role: UserRole = Field(..., description="Expected role: buyer or seller")
    full_name: Optional[str] = Field("", description="Full name of user")
    phone_number: Optional[str] = Field("", description="Phone number")
    company_name: Optional[str] = Field("", description="Company name")
    city: Optional[str] = Field("", description="City")
    area: Optional[str] = Field("", description="Area")
    address: Optional[str] = Field("", description="Complete address")
    company_type: Optional[str] = Field(None, description="Company type")
    gst_number: Optional[str] = Field(None, description="GST number")
    latitude: Optional[float] = Field(None, description="User Latitude")
    longitude: Optional[float] = Field(None, description="User Longitude")
    email_verified: bool = Field(False, description="Whether email is verified")
    phone_verified: bool = Field(False, description="Whether phone is verified via 2FA")
    two_factor_enabled: bool = Field(False, description="Whether 2FA is active")
    fcm_token: Optional[str] = Field(None, description="FCM device push token")


class RegisterResponse(LoginResponse):
    masked_phone: str = Field(..., description="Masked phone number for OTP UI")


class ForgotPasswordRequest(BaseModel):
    email: str = Field(..., description="User email for password reset")


class ForgotPasswordResponse(BaseModel):
    message: str = "Password reset code sent successfully."
    masked_email: str = Field(..., description="Masked email for display, e.g. j***e@example.com")


class VerifyOtpRequest(BaseModel):
    email: str = Field(..., description="User email")
    otp: str = Field(..., min_length=6, max_length=6, description="6-digit OTP code")


class VerifyOtpResponse(BaseModel):
    reset_token: str = Field(..., description="Short-lived token required to reset password")
    message: str = "OTP verified successfully."


class ResetPasswordRequest(BaseModel):
    email: str = Field(..., description="User email")
    reset_token: str = Field(..., description="Token obtained from verifying OTP")
    new_password: str = Field(..., min_length=6, description="New password (min 6 characters)")


class ResetPasswordResponse(BaseModel):
    message: str = "Password has been reset successfully."


class Toggle2FARequest(BaseModel):
    enabled: bool = Field(..., description="Enable or disable 2FA")


class FcmTokenRequest(BaseModel):
    token: str = Field(..., description="FCM device registration token")


class ChangePasswordRequest(BaseModel):
    current_password: str = Field(..., min_length=6, description="Current user password")
    new_password: str = Field(..., min_length=6, description="New password (min 6 characters)")


class UserPreferencesModel(BaseModel):
    # Seller preferences
    listing_updates: Optional[bool] = True
    price_offers: Optional[bool] = True
    product_updates: Optional[bool] = False
    # Buyer preferences
    new_auctions: Optional[bool] = True
    bid_updates: Optional[bool] = True
    closing_soon_alerts: Optional[bool] = False
    winning_notifications: Optional[bool] = True
    # Admin / general notification preferences
    email_user_approvals: Optional[bool] = True
    email_new_bids: Optional[bool] = True
    email_facebook_leads: Optional[bool] = True
    push_notifications: Optional[bool] = True
    push_deal_updates: Optional[bool] = False
    sms_facebook_leads: Optional[bool] = False
    login_alerts: Optional[bool] = True
    trusted_devices_only: Optional[bool] = False


class SessionItem(BaseModel):
    id: str
    device: str
    location: str
    time: str
    is_current: bool = False
    ip_address: Optional[str] = None
    created_at: Optional[str] = None


class SessionListResponse(BaseModel):
    sessions: List[SessionItem] = []

