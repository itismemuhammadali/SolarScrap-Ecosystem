#!/usr/bin/env python3
"""
Seed script to create default test users in Firebase Emulator (Auth & Firestore).
Run this after starting the Firebase Emulator.
"""
import os
import sys
import firebase_admin
from firebase_admin import auth, firestore
from google.auth.credentials import AnonymousCredentials

# Set emulator environment variables
os.environ["FIREBASE_AUTH_EMULATOR_HOST"] = "localhost:9099"
os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"

# Initialize Firebase Admin SDK
try:
    app = firebase_admin.get_app()
except ValueError:
    app = firebase_admin.initialize_app(
        credential=AnonymousCredentials(),
        options={"projectId": "solar-scrap-demo"}
    )

db = firestore.client()

TEST_USERS = [
    {
        "email": "buyer@solarscrap.com",
        "password": "Password123!",
        "display_name": "Demo Buyer",
        "phone_number": "+92 300 1234567",
        "role": "buyer",
        "company_name": "SunTech Solar Pvt. Ltd.",
        "city": "Karachi",
        "area": "SITE Industrial Area",
        "address": "Plot 12, Sector 5, SITE Industrial Area",
        "company_type": "Private Limited",
        "gst_number": "22AAAAA0000A1Z5",
    },
    {
        "email": "seller@solarscrap.com",
        "password": "Password123!",
        "display_name": "Abdul Samad",
        "phone_number": "+92 334 5678974",
        "role": "seller",
        "company_name": "SunTech Solar Pvt. Ltd.",
        "city": "Karachi",
        "area": "Korangi Industrial Area",
        "address": "Plot 45, Main Industrial Boulevard",
        "company_type": "Private Limited",
        "gst_number": "22AAAAA0000A1Z5",
    },
]


def seed():
    print("==================================================")
    print("🌱 Seeding Firebase Emulator Test Users...")
    print("==================================================")

    for user_info in TEST_USERS:
        email = user_info["email"]
        password = user_info["password"]
        role = user_info["role"]
        display_name = user_info["display_name"]
        phone_number = user_info.get("phone_number")

        # 1. Create or update user in Firebase Auth
        try:
            user_record = auth.get_user_by_email(email)
            print(f"[*] User '{email}' already exists (UID: {user_record.uid}). Updating password...")
            auth.update_user(
                user_record.uid,
                password=password,
                display_name=display_name,
            )
            uid = user_record.uid
        except auth.UserNotFoundError:
            user_record = auth.create_user(
                email=email,
                password=password,
                display_name=display_name,
                email_verified=True,
            )
            uid = user_record.uid
            print(f"[+] Created new Auth user '{email}' (UID: {uid})")

        # 2. Assign custom claims
        auth.set_custom_user_claims(uid, {"role": role})

        # 3. Store user document in Firestore
        user_doc_ref = db.collection("users").document(uid)
        user_doc_ref.set(
            {
                "uid": uid,
                "email": email,
                "role": role,
                "display_name": display_name,
                "phone_number": phone_number,
                "company_name": user_info.get("company_name"),
                "city": user_info.get("city"),
                "area": user_info.get("area"),
                "address": user_info.get("address"),
                "company_type": user_info.get("company_type"),
                "gst_number": user_info.get("gst_number"),
                "updated_at": firestore.SERVER_TIMESTAMP,
            },
            merge=True,
        )
        print(f"[+] Firestore profile stored for '{email}' with role: '{role}'")

    print("\n✅ Seeding complete!")
    print("--------------------------------------------------")
    print("Test Credentials:")
    for user in TEST_USERS:
        print(f"  • Role: {user['role'].upper()}")
        print(f"    Email:    {user['email']}")
        print(f"    Password: {user['password']}\n")
    print("==================================================")


if __name__ == "__main__":
    try:
        seed()
    except Exception as ex:
        print(f"\n❌ Error during seeding: {ex}")
        print("Make sure the Firebase emulator is running: 'firebase emulators:start --only auth,firestore'")
        sys.exit(1)
