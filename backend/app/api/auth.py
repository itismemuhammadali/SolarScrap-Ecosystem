from fastapi import APIRouter, HTTPException, Depends, status, Header
from firebase_admin import auth, firestore
from app.schemas.auth import (
    LoginRequest,
    LoginResponse,
    UserProfile,
    UserRole,
    RegisterRequest,
    RegisterResponse,
    UpdateProfileRequest,
    SellerStatsResponse,
)
from app.core.firebase import verify_password_with_firebase, get_firestore_db

router = APIRouter(prefix="/auth", tags=["Authentication"])


async def get_current_user(authorization: str = Header(...)) -> UserProfile:
    """Dependency to verify Firebase ID Token from Authorization header."""
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication header format. Expected 'Bearer <token>'",
        )
    token = authorization.split("Bearer ")[1]
    try:
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token.get("uid")
        email = decoded_token.get("email", "")

        # Fetch full profile from Firestore
        db = get_firestore_db()
        user_doc = db.collection("users").document(uid).get()
        role = UserRole.BUYER
        display_name = decoded_token.get("name", "")
        phone_number = None
        company_name = None
        city = None
        area = None
        address = None
        company_type = None
        gst_number = None
        profile_photo_url = None

        if user_doc.exists:
            user_data = user_doc.to_dict() or {}
            role = user_data.get("role", UserRole.BUYER)
            display_name = user_data.get("display_name", display_name)
            phone_number = user_data.get("phone_number")
            company_name = user_data.get("company_name")
            city = user_data.get("city")
            area = user_data.get("area")
            address = user_data.get("address")
            company_type = user_data.get("company_type")
            gst_number = user_data.get("gst_number")
            profile_photo_url = user_data.get("profile_photo_url")

        return UserProfile(
            user_id=uid,
            email=email,
            role=UserRole(role),
            display_name=display_name,
            phone_number=phone_number,
            company_name=company_name,
            city=city,
            area=area,
            address=address,
            company_type=company_type,
            gst_number=gst_number,
            profile_photo_url=profile_photo_url,
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid or expired token: {str(e)}",
        )


@router.post("/login", response_model=LoginResponse)
async def login(payload: LoginRequest):
    """
    Sign in for Buyer or Seller.
    Authenticates against Firebase and ensures the user has the correct role.
    """
    # 1. Authenticate with Firebase Auth (supports emulator & cloud)
    auth_result = await verify_password_with_firebase(payload.email, payload.password)

    if not auth_result.get("success"):
        error_code = auth_result.get("error", "")
        if "EMAIL_NOT_FOUND" in error_code or "INVALID_PASSWORD" in error_code or "INVALID_LOGIN_CREDENTIALS" in error_code:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password.",
            )
        elif "USER_DISABLED" in error_code:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="This account has been disabled. Please contact support.",
            )
        else:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Authentication failed: {error_code}",
            )

    uid = auth_result["local_id"]
    id_token = auth_result["id_token"]
    email = auth_result.get("email", payload.email)

    # 2. Check user profile and role in Firestore
    db = get_firestore_db()
    user_ref = db.collection("users").document(uid)
    user_doc = user_ref.get()

    if user_doc.exists:
        user_data = user_doc.to_dict() or {}
        registered_role = user_data.get("role", payload.role.value)
        display_name = user_data.get("display_name", auth_result.get("display_name", ""))
        phone = user_data.get("phone_number")
        company_name = user_data.get("company_name")
        city = user_data.get("city")
        area = user_data.get("area")
        address = user_data.get("address")
        company_type = user_data.get("company_type")
        gst_number = user_data.get("gst_number")
        profile_photo_url = user_data.get("profile_photo_url")

        # Validate Role matching
        if registered_role.lower() != payload.role.value.lower():
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. This account is registered as a '{registered_role}', not a '{payload.role.value}'. Please use the correct portal.",
            )
    else:
        # Create Firestore user record if not yet created (e.g. initial emulator sign-in)
        registered_role = payload.role.value
        display_name = auth_result.get("display_name") or email.split("@")[0].capitalize()
        phone = None
        company_name = None
        city = None
        area = None
        address = None
        company_type = None
        gst_number = None
        profile_photo_url = None
        user_ref.set({
            "email": email,
            "role": registered_role,
            "display_name": display_name,
            "created_at": firestore.SERVER_TIMESTAMP,
        })

    user_profile = UserProfile(
        user_id=uid,
        email=email,
        role=UserRole(registered_role),
        display_name=display_name,
        phone_number=phone,
        company_name=company_name,
        city=city,
        area=area,
        address=address,
        company_type=company_type,
        gst_number=gst_number,
        profile_photo_url=profile_photo_url,
    )

    return LoginResponse(
        access_token=id_token,
        token_type="bearer",
        user=user_profile,
        message=f"Welcome {display_name or email}! Successfully signed in as {registered_role}.",
    )


@router.get("/me", response_model=UserProfile)
async def get_me(current_user: UserProfile = Depends(get_current_user)):
    """Get profile of current authenticated user."""
    return current_user


@router.patch("/profile", response_model=UserProfile)
@router.put("/profile", response_model=UserProfile)
async def update_profile(
    payload: UpdateProfileRequest,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Update profile details for the authenticated user in Firestore and Firebase Auth.
    """
    db = get_firestore_db()
    user_ref = db.collection("users").document(current_user.user_id)
    
    update_data = {}
    if payload.display_name is not None:
        update_data["display_name"] = payload.display_name.strip()
    if payload.phone_number is not None:
        update_data["phone_number"] = payload.phone_number.strip()
    if payload.company_name is not None:
        update_data["company_name"] = payload.company_name.strip()
    if payload.city is not None:
        update_data["city"] = payload.city.strip()
    if payload.area is not None:
        update_data["area"] = payload.area.strip()
    if payload.address is not None:
        update_data["address"] = payload.address.strip()
    if payload.company_type is not None:
        update_data["company_type"] = payload.company_type.strip()
    if payload.gst_number is not None:
        update_data["gst_number"] = payload.gst_number.strip()
    if payload.profile_photo_url is not None:
        update_data["profile_photo_url"] = payload.profile_photo_url.strip()

    if update_data:
        update_data["updated_at"] = firestore.SERVER_TIMESTAMP
        user_ref.set(update_data, merge=True)

        # Also update display name in Firebase Auth
        if "display_name" in update_data:
            try:
                auth.update_user(current_user.user_id, display_name=update_data["display_name"])
            except Exception:
                pass

    # Read back updated profile
    updated_doc = user_ref.get()
    updated_data = updated_doc.to_dict() or {}

    return UserProfile(
        user_id=current_user.user_id,
        email=current_user.email,
        role=current_user.role,
        display_name=updated_data.get("display_name", current_user.display_name),
        phone_number=updated_data.get("phone_number", current_user.phone_number),
        company_name=updated_data.get("company_name", current_user.company_name),
        city=updated_data.get("city", current_user.city),
        area=updated_data.get("area", current_user.area),
        address=updated_data.get("address", current_user.address),
        company_type=updated_data.get("company_type", current_user.company_type),
        gst_number=updated_data.get("gst_number", current_user.gst_number),
        profile_photo_url=updated_data.get("profile_photo_url", current_user.profile_photo_url),
    )


@router.get("/stats", response_model=SellerStatsResponse)
@router.get("/seller-stats", response_model=SellerStatsResponse)
async def get_seller_stats(current_user: UserProfile = Depends(get_current_user)):
    """
    Get dashboard stats (listings count, deals count, total earnings) for seller from Firestore.
    """
    db = get_firestore_db()
    # Check listings collection for this user if it exists
    listings_ref = db.collection("listings").where("seller_id", "==", current_user.user_id)
    listings = list(listings_ref.stream())
    listings_count = len(listings)
    
    deals_count = 0
    total_earnings_val = 0
    for doc in listings:
        data = doc.to_dict()
        status_val = str(data.get("status", "")).lower()
        if status_val in ["closed", "deal closed", "sold", "deal_closed"]:
            deals_count += 1
            total_earnings_val += float(data.get("final_price", 0) or data.get("price_demand", 0) or 0)

    if total_earnings_val >= 100000:
        earnings_str = f"Rs. {total_earnings_val / 100000:.1f}L"
    elif total_earnings_val > 0:
        earnings_str = f"Rs. {int(total_earnings_val):,}"
    else:
        earnings_str = "Rs. 0"

    return SellerStatsResponse(
        listings_count=listings_count,
        deals_count=deals_count,
        total_earnings=earnings_str,
    )


@router.post("/register", response_model=RegisterResponse, status_code=status.HTTP_201_CREATED)
async def register(payload: RegisterRequest):
    """
    Register a new Buyer or Seller.
    Creates user in Firebase Auth, stores role in Firestore, and returns auth token.
    """
    # 1. Create user in Firebase Auth
    try:
        user_record = auth.create_user(
            email=payload.email,
            password=payload.password,
            display_name=payload.full_name,
        )
        uid = user_record.uid
    except auth.EmailAlreadyExistsError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This email is already registered.",
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Registration failed: {str(e)}",
        )

    # 2. Set custom claims (optional but good for security)
    auth.set_custom_user_claims(uid, {"role": payload.role.value})

    # 3. Create Firestore record
    db = get_firestore_db()
    user_ref = db.collection("users").document(uid)
    user_ref.set({
        "email": payload.email,
        "role": payload.role.value,
        "display_name": payload.full_name,
        "phone_number": payload.phone_number,
        "company_name": payload.company_name,
        "city": payload.city,
        "area": payload.area,
        "address": payload.address,
        "company_type": payload.company_type,
        "gst_number": payload.gst_number,
        "created_at": firestore.SERVER_TIMESTAMP,
    })

    # 4. Sign in to get ID token
    auth_result = await verify_password_with_firebase(payload.email, payload.password)
    
    if not auth_result.get("success"):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="User created but failed to generate access token.",
        )

    id_token = auth_result["id_token"]

    user_profile = UserProfile(
        user_id=uid,
        email=payload.email,
        role=payload.role,
        display_name=payload.full_name,
        phone_number=payload.phone_number,
        company_name=payload.company_name,
        city=payload.city,
        area=payload.area,
        address=payload.address,
        company_type=payload.company_type,
        gst_number=payload.gst_number,
    )
    
    # Mask phone for OTP UI (e.g. +923001234567 -> •••4567)
    masked = "•••" + payload.phone_number[-4:] if len(payload.phone_number) > 4 else "•••"

    return RegisterResponse(
        access_token=id_token,
        token_type="bearer",
        user=user_profile,
        message=f"Registration successful for {payload.full_name}",
        masked_phone=masked
    )


