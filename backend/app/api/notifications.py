from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends, status
from firebase_admin import firestore
from app.schemas.auth import UserProfile
from app.schemas.notifications import NotificationResponse
from app.api.auth import get_current_user
from app.core.firebase import get_firestore_db

router = APIRouter(prefix="/notifications", tags=["Notifications"])


def _format_datetime(dt):
    if dt is None:
        return None
    if hasattr(dt, "isoformat"):
        return dt.isoformat()
    return str(dt)


def create_user_notification(
    db,
    user_id: str,
    notif_type: str,
    title: str,
    description: str,
    listing_id: Optional[str] = None,
):
    """
    Helper function to insert a notification document into Firestore
    subcollection: users/{user_id}/notifications/{notif_id}
    """
    try:
        notif_ref = (
            db.collection("users")
            .document(user_id)
            .collection("notifications")
            .document()
        )
        notif_data = {
            "user_id": user_id,
            "type": notif_type,
            "title": title,
            "description": description,
            "listing_id": listing_id,
            "is_read": False,
            "created_at": firestore.SERVER_TIMESTAMP,
        }
        notif_ref.set(notif_data)
        return notif_ref.id
    except Exception as e:
        print(f"[Notifications] Error creating notification: {e}")
        return None


@router.get("", response_model=List[NotificationResponse])
async def get_my_notifications(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Fetch all notifications for the authenticated user, newest first.
    If no notifications exist in Firestore, seed default starter notifications.
    """
    db = get_firestore_db()
    try:
        notifs_ref = (
            db.collection("users")
            .document(current_user.user_id)
            .collection("notifications")
        )
        docs = notifs_ref.order_by(
            "created_at", direction=firestore.Query.DESCENDING
        ).stream()

        results = []
        for doc in docs:
            data = doc.to_dict()
            results.append(
                NotificationResponse(
                    id=doc.id,
                    user_id=data.get("user_id", current_user.user_id),
                    type=data.get("type", "listing_created"),
                    title=data.get("title", ""),
                    description=data.get("description", ""),
                    listing_id=data.get("listing_id"),
                    is_read=bool(data.get("is_read", False)),
                    created_at=_format_datetime(data.get("created_at")),
                )
            )

        # If user has no notifications yet, seed default welcome / profile verified notification
        if not results:
            welcome_id = create_user_notification(
                db=db,
                user_id=current_user.user_id,
                notif_type="profile_verified",
                title="Profile Verified",
                description="Your company documents and seller profile have been verified successfully.",
            )
            if welcome_id:
                results.append(
                    NotificationResponse(
                        id=welcome_id,
                        user_id=current_user.user_id,
                        type="profile_verified",
                        title="Profile Verified",
                        description="Your company documents and seller profile have been verified successfully.",
                        listing_id=None,
                        is_read=False,
                        created_at=None,
                    )
                )

        return results
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch notifications: {str(e)}",
        )


@router.post("/{notification_id}/read")
async def mark_notification_read(
    notification_id: str,
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Mark a single notification as read.
    """
    db = get_firestore_db()
    try:
        notif_ref = (
            db.collection("users")
            .document(current_user.user_id)
            .collection("notifications")
            .document(notification_id)
        )
        notif_ref.update({"is_read": True})
        return {"success": True, "message": "Notification marked as read"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update notification: {str(e)}",
        )


@router.post("/read-all")
async def mark_all_notifications_read(
    current_user: UserProfile = Depends(get_current_user),
):
    """
    Mark all notifications for current user as read.
    """
    db = get_firestore_db()
    try:
        notifs_ref = (
            db.collection("users")
            .document(current_user.user_id)
            .collection("notifications")
        )
        docs = notifs_ref.stream()
        batch = db.batch()
        count = 0
        for doc in docs:
            batch.update(doc.reference, {"is_read": True})
            count += 1
            if count >= 450:
                batch.commit()
                batch = db.batch()
                count = 0
        if count > 0:
            batch.commit()

        return {"success": True, "message": "All notifications marked as read"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to mark all as read: {str(e)}",
        )
