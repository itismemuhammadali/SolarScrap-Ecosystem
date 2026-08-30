import os
import shutil
import asyncio
import threading
from fastapi import APIRouter, HTTPException, Depends, status, UploadFile, File, BackgroundTasks
from fastapi.responses import FileResponse
from firebase_admin import firestore
from app.schemas.auth import UserProfile
from app.api.auth import get_current_user
from app.core.firebase import get_firestore_db, get_storage_bucket
from app.core.config import settings

router = APIRouter(prefix="/storage", tags=["Storage"])

# Local uploads directories
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "uploads", "profile_photos")
LISTING_UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "uploads", "listing_images")
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(LISTING_UPLOAD_DIR, exist_ok=True)


def _upload_to_firebase_background(blob_path: str, local_path: str, mime_type: str):
    """
    Fire-and-forget background upload to Firebase Storage.
    Runs in a daemon thread so it never blocks the HTTP response.
    """
    try:
        bucket = get_storage_bucket()
        blob = bucket.blob(blob_path)
        blob.upload_from_filename(local_path, content_type=mime_type)
        if not settings.USE_EMULATOR:
            blob.make_public()
        print(f"[Storage] Background upload done: {blob_path}")
    except Exception as e:
        print(f"[Storage Warning] Background Firebase upload error for {blob_path}: {e}")


@router.post("/upload-profile-photo")
async def upload_profile_photo(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Upload a profile picture for the authenticated user.
    Saves locally first and responds immediately.
    Firebase Storage upload happens in the background.
    """
    valid_exts = {".jpg", ".jpeg", ".png", ".webp", ".heic", ".gif", ".bmp"}
    file_extension = os.path.splitext(file.filename or "")[1].lower() or ".jpg"
    is_image_mime = bool(
        file.content_type
        and (file.content_type.startswith("image/") or file.content_type == "application/octet-stream")
    )

    if not (is_image_mime or file_extension in valid_exts):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Uploaded file must be an image (JPEG, PNG, WebP).",
        )

    filename = f"{current_user.user_id}{file_extension}"
    local_path = os.path.join(UPLOAD_DIR, filename)

    # 1. Save locally (fast — always succeeds)
    try:
        content = await file.read()
        with open(local_path, "wb") as buffer:
            buffer.write(content)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save image locally: {str(e)}",
        )

    # 2. Construct URL — served immediately from local disk
    photo_url = f"/api/v1/storage/profile-photo/{current_user.user_id}?v={int(os.path.getmtime(local_path))}"

    # 3. Update Firestore (fast)
    try:
        db = get_firestore_db()
        user_ref = db.collection("users").document(current_user.user_id)
        user_ref.set(
            {"profile_photo_url": photo_url, "updated_at": firestore.SERVER_TIMESTAMP},
            merge=True,
        )
    except Exception as e:
        print(f"[Storage Warning] Firestore update error: {e}")

    # 4. Fire-and-forget: upload to Firebase Storage in background thread
    mime_type = file.content_type if (file.content_type and file.content_type.startswith("image/")) else "image/jpeg"
    t = threading.Thread(
        target=_upload_to_firebase_background,
        args=(f"profile_photos/{filename}", local_path, mime_type),
        daemon=True,
    )
    t.start()

    return {
        "success": True,
        "message": "Profile photo uploaded successfully",
        "profile_photo_url": photo_url,
    }


@router.get("/profile-photo/{user_id}")
async def get_profile_photo(user_id: str):
    """
    Serve the profile photo for a user.
    """
    for ext in [".jpg", ".jpeg", ".png", ".webp", ""]:
        path = os.path.join(UPLOAD_DIR, f"{user_id}{ext}")
        if os.path.exists(path) and os.path.isfile(path):
            return FileResponse(path)

    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Profile photo not found")


@router.post("/upload-listing-image")
async def upload_listing_image(
    file: UploadFile = File(...),
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Upload an equipment image for a listing.
    Saves locally first and responds immediately (< 1s).
    Firebase Storage upload happens in a background thread.
    """
    import uuid
    import time

    valid_exts = {".jpg", ".jpeg", ".png", ".webp", ".heic", ".gif", ".bmp"}
    file_extension = os.path.splitext(file.filename or "")[1].lower() or ".jpg"
    is_image_mime = bool(
        file.content_type
        and (file.content_type.startswith("image/") or file.content_type == "application/octet-stream")
    )

    if not (is_image_mime or file_extension in valid_exts):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Uploaded file must be an image (JPEG, PNG, WebP).",
        )

    unique_filename = f"{current_user.user_id}_{int(time.time())}_{uuid.uuid4().hex[:8]}{file_extension}"
    local_path = os.path.join(LISTING_UPLOAD_DIR, unique_filename)

    # 1. Read and save locally (fast)
    try:
        content = await file.read()
        with open(local_path, "wb") as buffer:
            buffer.write(content)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save listing image locally: {str(e)}",
        )

    # 2. Respond immediately with the local-serve URL
    image_url = f"/api/v1/storage/listing-image/{unique_filename}"

    # 3. Fire-and-forget: upload to Firebase Storage in a background thread
    mime_type = file.content_type if (file.content_type and file.content_type.startswith("image/")) else "image/jpeg"
    t = threading.Thread(
        target=_upload_to_firebase_background,
        args=(f"listing_images/{unique_filename}", local_path, mime_type),
        daemon=True,
    )
    t.start()

    return {
        "success": True,
        "filename": unique_filename,
        "url": image_url,
    }


@router.get("/listing-image/{filename}")
async def get_listing_image(filename: str):
    """
    Serve a listing image from local disk.
    """
    path = os.path.join(LISTING_UPLOAD_DIR, filename)
    if os.path.exists(path) and os.path.isfile(path):
        return FileResponse(path)

    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Listing image not found")
