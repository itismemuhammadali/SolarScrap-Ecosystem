import os
import firebase_admin
from firebase_admin import credentials, auth, firestore, storage
from google.auth.credentials import AnonymousCredentials
import httpx
from app.core.config import settings

_firebase_app = None
_firestore_client = None
_storage_bucket = None


def init_firebase():
    """Initialize Firebase Admin SDK based on emulator or production mode."""
    global _firebase_app, _firestore_client, _storage_bucket

    if _firebase_app is not None:
        return _firebase_app

    if settings.USE_EMULATOR:
        # Configure environment for Firebase Admin SDK to target local emulators
        os.environ["FIREBASE_AUTH_EMULATOR_HOST"] = settings.FIREBASE_AUTH_EMULATOR_HOST
        os.environ["FIRESTORE_EMULATOR_HOST"] = settings.FIRESTORE_EMULATOR_HOST
        os.environ["STORAGE_EMULATOR_HOST"] = f"http://{settings.FIREBASE_STORAGE_EMULATOR_HOST}"
        os.environ["FIREBASE_STORAGE_EMULATOR_HOST"] = f"http://{settings.FIREBASE_STORAGE_EMULATOR_HOST}"
        
        # When using emulator, AnonymousCredentials allows local operations without GCP login
        _firebase_app = firebase_admin.initialize_app(
            credential=AnonymousCredentials(),
            options={
                "projectId": settings.FIREBASE_PROJECT_ID,
                "storageBucket": settings.FIREBASE_STORAGE_BUCKET,
            },
        )
        print(f"[Firebase] Initialized in EMULATOR mode (Auth: {settings.FIREBASE_AUTH_EMULATOR_HOST}, Firestore: {settings.FIRESTORE_EMULATOR_HOST}, Storage: {settings.FIREBASE_STORAGE_EMULATOR_HOST})")
    else:
        # Production Firebase Initialization
        options = {
            "projectId": settings.FIREBASE_PROJECT_ID,
            "storageBucket": settings.FIREBASE_STORAGE_BUCKET,
        }
        try:
            if settings.FIREBASE_CREDENTIALS_PATH and os.path.exists(settings.FIREBASE_CREDENTIALS_PATH):
                os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.path.abspath(settings.FIREBASE_CREDENTIALS_PATH)
                cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
                _firebase_app = firebase_admin.initialize_app(cred, options=options)
            else:
                _firebase_app = firebase_admin.initialize_app(options=options)
            print(f"[Firebase] Initialized in PRODUCTION mode for project '{settings.FIREBASE_PROJECT_ID}'")
        except Exception as e:
            print(f"[Firebase] Warning: Could not initialize production Firebase ({e}). Waiting for serviceAccountKey.json.")
            return None

    try:
        _firestore_client = firestore.client(app=_firebase_app)
        print("[Firebase] Firestore client connected successfully!")
    except Exception as e:
        print(f"[Firebase] Firestore client init error: {e}")
    return _firebase_app


def get_firestore_db():
    if _firestore_client is None:
        init_firebase()
    return _firestore_client


def get_storage_bucket():
    global _storage_bucket
    if _firebase_app is None:
        init_firebase()
    if _storage_bucket is None:
        _storage_bucket = storage.bucket()
    return _storage_bucket


async def verify_password_with_firebase(email: str, password: str) -> dict:
    """
    Authenticate user using Firebase Auth REST API.
    Works seamlessly against local Auth Emulator or Google Cloud Firebase Auth.
    """
    if settings.USE_EMULATOR:
        url = f"http://{settings.FIREBASE_AUTH_EMULATOR_HOST}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=emulator-key"
    else:
        api_key = settings.FIREBASE_WEB_API_KEY
        if not api_key:
            raise ValueError("FIREBASE_WEB_API_KEY is not configured for production auth.")
        url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={api_key}"

    payload = {
        "email": email,
        "password": password,
        "returnSecureToken": True,
    }

    async with httpx.AsyncClient(timeout=10.0) as client:
        response = await client.post(url, json=payload)
        data = response.json()

        if response.status_code != 200:
            error_message = data.get("error", {}).get("message", "INVALID_LOGIN_CREDENTIALS")
            return {"success": False, "error": error_message}

        return {
            "success": True,
            "id_token": data.get("idToken"),
            "refresh_token": data.get("refreshToken"),
            "expires_in": data.get("expiresIn"),
            "local_id": data.get("localId"),
            "email": data.get("email"),
            "display_name": data.get("displayName", ""),
        }
