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

from app.core.config import settings
from app.core.firebase import init_firebase, get_firestore_db

init_firebase()
db = get_firestore_db()

TEST_USERS = [
    {
        "email": "admin@solarscrap.com",
        "password": "Password123!",
        "display_name": "Admin User",
        "phone_number": "+92 300 0000000",
        "role": "admin",
        "company_name": "Solar Scrap Admin HQ",
        "city": "Karachi",
        "area": "Clifton",
        "address": "Solar Scrap HQ, Suite 100",
        "company_type": "Headquarters",
        "gst_number": "22AAAAA0000A1Z5",
    },
    {
        "email": "solarscrap.info@gmail.com",
        "password": "Password123!",
        "display_name": "Solar Scrap Admin",
        "phone_number": "+92 300 9876543",
        "role": "admin",
        "company_name": "Solar Scrap Portal",
        "city": "Karachi",
        "area": "Main Boulevard",
        "address": "Solar Scrap Office 12",
        "company_type": "Headquarters",
        "gst_number": "22AAAAA0000A1Z5",
        "status": "Approved",
    },
    {
        "email": "buyer@solarscrap.com",
        "password": "Password123!",
        "display_name": "Demo Buyer",
        "phone_number": "+92 300 1234567",
        "role": "buyer",
        "status": "Approved",
        "company_name": "SunTech Solar Pvt. Ltd.",
        "city": "Karachi",
        "area": "SITE Industrial Area",
        "address": "Plot 12, Sector 5, SITE Industrial Area",
        "company_type": "Private Limited",
        "gst_number": "22AAAAA0000A1Z5",
    },
    {
        "email": "pending_dealer@solarscrap.com",
        "password": "Password123!",
        "display_name": "Kamran Traders",
        "phone_number": "+92 321 9988776",
        "role": "buyer",
        "status": "Pending",
        "company_name": "Kamran Scrap Corporation",
        "city": "Lahore",
        "area": "Badami Bagh",
        "address": "Shop 14, Metal Market, Badami Bagh",
        "company_type": "Partnership",
        "gst_number": "22BBBBB1111B2Z6",
    },
    {
        "email": "seller@solarscrap.com",
        "password": "Password123!",
        "display_name": "Abdul Samad",
        "phone_number": "+92 334 5678974",
        "role": "seller",
        "status": "Approved",
        "company_name": "SunTech Solar Pvt. Ltd.",
        "city": "Karachi",
        "area": "Korangi Industrial Area",
        "address": "Plot 45, Main Industrial Boulevard",
        "company_type": "Private Limited",
        "gst_number": "22AAAAA0000A1Z5",
    },
    {
        "email": "pending_seller@solarscrap.com",
        "password": "Password123!",
        "display_name": "Hassan Raza",
        "phone_number": "+92 345 1122334",
        "role": "seller",
        "status": "Pending",
        "company_name": "Raza Industrial EPC",
        "city": "Faisalabad",
        "area": "Sargodha Road",
        "address": "Mill 4, Industrial Area",
        "company_type": "Sole Proprietorship",
        "gst_number": "22CCCCC2222C3Z7",
    },
]


TEST_LEADS = [
    {
        "id": "lead_demo_01",
        "lead_id": "FB001",
        "name": "Kamran Sheikh",
        "phone": "+92 300 1112222",
        "email": "kamran@gmail.com",
        "city": "Karachi",
        "area": "Clifton",
        "status": "New",
        "source": "Facebook Campaign",
        "received_date": "2024-12-07",
        "notes": ["Customer submitted inquiry for 120x solar panels."],
    },
    {
        "id": "lead_demo_02",
        "lead_id": "FB002",
        "name": "Fatima Zahra",
        "phone": "+92 321 3334444",
        "email": "fatima@yahoo.com",
        "city": "Lahore",
        "area": "Johar Town",
        "status": "New",
        "source": "Facebook Campaign",
        "received_date": "2024-12-07",
        "notes": ["Inverter 15kW + battery bank ready for inspection."],
    },
    {
        "id": "lead_demo_03",
        "lead_id": "FB003",
        "name": "Imran Siddiqui",
        "phone": "+92 333 5556666",
        "email": "imran@hotmail.com",
        "city": "Islamabad",
        "area": "G-11",
        "status": "Contacted",
        "source": "Facebook Campaign",
        "received_date": "2024-12-07",
        "notes": ["400x Mono PERC panels. Awaiting site visit confirmation."],
    },
    {
        "id": "lead_demo_04",
        "lead_id": "FB004",
        "name": "Zainab Hassan",
        "phone": "+92 312 7778888",
        "email": "zainab@gmail.com",
        "city": "Karachi",
        "area": "DHA",
        "status": "Follow-up",
        "source": "Facebook Campaign",
        "received_date": "2024-12-07",
        "notes": ["Heavy DC Copper Cables ~500kg."],
    },
    {
        "id": "lead_demo_05",
        "lead_id": "FB005",
        "name": "Ahmed Raza",
        "phone": "+92 345 9990000",
        "email": "ahmed@live.com",
        "city": "Rawalpindi",
        "area": "Bahria Town",
        "status": "Converted",
        "source": "Facebook Campaign",
        "received_date": "2024-12-07",
        "notes": ["Narada Lithium 48V Battery Bank scrap offer."],
    },
]


def seed():
    print("==================================================")
    print("🌱 Seeding Firebase Emulator Test Users & Leads...")
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
                "status": user_info.get("status", "Approved"),
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
        print(f"[+] Firestore profile stored for '{email}' with role: '{role}' (Status: {user_info.get('status', 'Approved')})")

    print("\n--------------------------------------------------")
    print("📥 Seeding Facebook Leads...")
    for lead in TEST_LEADS:
        lead_ref = db.collection("facebook_leads").document(lead["id"])
        lead_ref.set({
            "lead_id": lead["lead_id"],
            "name": lead["name"],
            "phone": lead["phone"],
            "email": lead["email"],
            "city": lead["city"],
            "area": lead["area"],
            "status": lead["status"],
            "source": lead["source"],
            "notes": lead["notes"],
            "created_at": firestore.SERVER_TIMESTAMP,
            "received_date": lead["received_date"],
        }, merge=True)
        print(f"[+] Seeded Facebook Lead {lead['lead_id']} ({lead['name']} - {lead['city']})")

    print("\n--------------------------------------------------")
    print("📦 Seeding Seller Posts (Listings)...")
    sample_listings = [
        {
            "id": "listing_seed_01",
            "post_id": "SP001",
            "seller_id": "seller_demo_uid",
            "category": "Solar Panels",
            "title": "200x Solar Panels 400W",
            "status": "active",
            "post_status": "New",
            "starting_price": 3800000.0,
            "price_demand": 4500000.0,
            "pickup_city": "Karachi",
            "pickup_area": "PECHS",
            "pickup_address": "Plot 45, PECHS Block 2, Karachi",
            "contact_name": "Sana Malik",
            "contact_phone": "+92 345 2223333",
            "contact_company": "Voltex Systems",
            "contact_email": "sana@voltex.pk",
            "specs": {
                "panels_count": 200,
                "watts_per_panel": "400W",
                "brand": "Waaree Energies",
                "manufacturer": "Waaree Energies",
                "purchase_year": "2019",
                "reason_for_sale": "Project Decommission",
                "panel_condition": "Good",
                "disassembly_state": "Dismantled & Packed",
                "estimated_weight": "~2,400 kg",
            },
            "image_urls": [
                "https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80",
                "https://images.unsplash.com/photo-1508873696983-2df57046475a?auto=format&fit=crop&w=600&q=80",
                "https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=600&q=80",
            ],
        },
        {
            "id": "listing_seed_02",
            "seller_id": "seller_demo_uid",
            "category": "Complete System",
            "title": "Complete Solar System",
            "status": "active",
            "post_status": "Under Review",
            "starting_price": 7000000.0,
            "price_demand": 8500000.0,
            "pickup_city": "Karachi",
            "pickup_area": "Clifton Block 4",
            "pickup_address": "Main Clifton Boulevard",
            "contact_name": "Sana Malik",
            "contact_phone": "+92 345 2223333",
            "contact_company": "Voltex Systems",
            "specs": {
                "quantity": 1,
                "condition": "Good",
                "estimated_weight": "2500 kg",
            },
            "image_urls": ["/images/complete-solar-system.jpg"],
        },
        {
            "id": "listing_seed_03",
            "seller_id": "seller_demo_uid",
            "category": "Batteries",
            "title": "16x Narada 48V Lithium Battery",
            "status": "draft",
            "post_status": "Price Offered",
            "starting_price": 1400000.0,
            "price_demand": 1680000.0,
            "offered_price": 1300000.0,
            "pickup_city": "Faisalabad",
            "pickup_area": "Millat Industrial Estate",
            "pickup_address": "Plot 12, Sector B",
            "contact_name": "Tariq Mahmood",
            "contact_phone": "+92 321 4455667",
            "contact_company": "Tariq Industrial Metals",
            "specs": {
                "batteries_count": 16,
                "battery_type": "LiFePO4 Lithium",
                "brand": "Narada",
                "model": "48V 100Ah",
                "battery_condition": "Used",
                "disassembly_state": "Rack Mounted",
                "estimated_weight": "720 kg",
            },
            "image_urls": ["/images/battery.png"],
        },
        {
            "id": "listing_seed_04",
            "seller_id": "seller_demo_uid",
            "category": "Transformers",
            "title": "250kVA Industrial Step-Down Transformer",
            "status": "Negotiation",
            "post_status": "Negotiation",
            "price_demand": 2100000.0,
            "pickup_city": "Rawalpindi",
            "pickup_area": "I-9 Industrial Area",
            "pickup_address": "Sector I-9/2",
            "contact_name": "Bilal Hussain",
            "contact_phone": "+92 321 9876543",
            "contact_company": "Scrap King",
            "specs": {
                "quantity": 1,
                "condition": "Used",
                "estimated_weight": "1100 kg",
            },
            "image_urls": ["/images/solar-panel.png"],
        },
        {
            "id": "listing_seed_05",
            "seller_id": "seller_demo_uid",
            "category": "Solar Panels",
            "title": "120x Canadian Solar 450W Panels",
            "status": "Auction",
            "post_status": "Auction",
            "price_demand": 2800000.0,
            "pickup_city": "Multan",
            "pickup_area": "Industrial Estate",
            "pickup_address": "Phase 2",
            "contact_name": "Hamza Khan",
            "contact_phone": "+92 300 4445555",
            "contact_company": "MetalZon",
            "specs": {
                "panels_count": 120,
                "watts_per_panel": "450",
                "brand": "Canadian Solar",
                "panel_condition": "Working",
                "estimated_weight": "2400 kg",
            },
            "image_urls": ["/images/solar-panel.png"],
        },
        {
            "id": "listing_seed_06",
            "seller_id": "seller_demo_uid",
            "category": "Batteries",
            "title": "24x Exide Deep Cycle Solar Batteries",
            "status": "Closed",
            "post_status": "Closed",
            "price_demand": 650000.0,
            "pickup_city": "Peshawar",
            "pickup_area": "Hayatabad Industrial Estate",
            "pickup_address": "Plot 88",
            "contact_name": "Usman Ali",
            "contact_phone": "+92 311 8889999",
            "contact_company": "RecyclePlus",
            "specs": {
                "batteries_count": 24,
                "battery_condition": "Scrap",
                "estimated_weight": "600 kg",
            },
            "image_urls": ["/images/battery.png"],
        },
    ]

    for item in sample_listings:
        listing_ref = db.collection("listings").document(item["id"])
        item_data = {**item, "created_at": firestore.SERVER_TIMESTAMP, "updated_at": firestore.SERVER_TIMESTAMP}
        listing_ref.set(item_data, merge=True)
        print(f"[+] Seeded Seller Post {item['id']} ({item['title']} - Status: {item['post_status']})")

    print("\n--------------------------------------------------")
    print("🔨 Seeding Bids...")
    sample_bids = [
        {
            "id": "bid_seed_01",
            "listing_id": "listing_seed_01",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Hamza Khan",
            "buyer_company": "MetalZon",
            "buyer_city": "Faisalabad",
            "buyer_phone": "+92 300 4445555",
            "buyer_email": "hamza@metalzon.pk",
            "amount": 195000.0,
            "status": "pending",
            "is_highest": False,
            "auction_id": "AUC001",
            "listing_title": "200x Solar Panels 400W",
            "listing_category": "Solar Panels",
            "submitted_date": "2024-12-06",
        },
        {
            "id": "bid_seed_02",
            "listing_id": "listing_seed_01",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Bilal Hussain",
            "buyer_company": "Scrap King",
            "buyer_city": "Lahore",
            "buyer_phone": "+92 321 9876543",
            "buyer_email": "bilal@scrapking.pk",
            "amount": 210000.0,
            "status": "pending",
            "is_highest": True,
            "auction_id": "AUC001",
            "listing_title": "200x Solar Panels 400W",
            "listing_category": "Solar Panels",
            "submitted_date": "2024-12-06",
        },
        {
            "id": "bid_seed_03",
            "listing_id": "listing_seed_01",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Usman Ali",
            "buyer_company": "RecyclePlus",
            "buyer_city": "Karachi",
            "buyer_phone": "+92 311 8889999",
            "buyer_email": "usman@recycleplus.pk",
            "amount": 188000.0,
            "status": "pending",
            "is_highest": False,
            "auction_id": "AUC001",
            "listing_title": "200x Solar Panels 400W",
            "listing_category": "Solar Panels",
            "submitted_date": "2024-12-05",
        },
        {
            "id": "bid_seed_04",
            "listing_id": "listing_seed_02",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Hamza Khan",
            "buyer_company": "MetalZon",
            "buyer_city": "Faisalabad",
            "buyer_phone": "+92 300 4445555",
            "buyer_email": "hamza@metalzon.pk",
            "amount": 7200000.0,
            "status": "pending",
            "is_highest": True,
            "auction_id": "AUC002",
            "listing_title": "Complete Solar System 50kW",
            "listing_category": "Complete System",
            "submitted_date": "2024-12-06",
        },
        {
            "id": "bid_seed_05",
            "listing_id": "listing_seed_04",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Bilal Hussain",
            "buyer_company": "Scrap King",
            "buyer_city": "Lahore",
            "buyer_phone": "+92 321 9876543",
            "buyer_email": "bilal@scrapking.pk",
            "amount": 980000.0,
            "status": "winner",
            "is_highest": False,
            "auction_id": "AUC004",
            "listing_title": "60x JA Solar Panels 330W",
            "listing_category": "Solar Panels",
            "submitted_date": "2024-11-25",
        },
        {
            "id": "bid_seed_06",
            "listing_id": "listing_seed_04",
            "seller_id": "seller_demo_uid",
            "buyer_id": "buyer_demo_uid",
            "buyer_name": "Hamza Khan",
            "buyer_company": "MetalZon",
            "buyer_city": "Faisalabad",
            "buyer_phone": "+92 300 4445555",
            "buyer_email": "hamza@metalzon.pk",
            "amount": 920000.0,
            "status": "lost",
            "is_highest": False,
            "auction_id": "AUC004",
            "listing_title": "60x JA Solar Panels 330W",
            "listing_category": "Solar Panels",
            "submitted_date": "2024-11-24",
        },
    ]
    for b in sample_bids:
        bid_ref = db.collection("bids").document(b["id"])
        bid_data = {**b, "created_at": firestore.SERVER_TIMESTAMP, "updated_at": firestore.SERVER_TIMESTAMP}
        bid_ref.set(bid_data, merge=True)
        print(f"[+] Seeded Bid {b['id']} (PKR {int(b['amount']):,} by {b['buyer_name']})")

    print("\n--------------------------------------------------")
    print("🔔 Seeding Admin Notifications...")
    sample_admin_notifications = [
        {
            "id": "admin_notif_01",
            "type": "new_user_registered",
            "title": "New User Registered",
            "description": "Abdul Samad registered as Seller (Karachi).",
            "entity_id": "seller_demo_uid",
            "entity_type": "user",
            "is_read": False,
        },
        {
            "id": "admin_notif_02",
            "type": "new_pending_post",
            "title": "New Post Awaiting Approval",
            "description": "180x Longi Hi-MO 5 540W Mono PERC Panels submitted by Abdul Samad — requires review.",
            "entity_id": "listing_seed_01",
            "entity_type": "listing",
            "is_read": False,
        },
        {
            "id": "admin_notif_03",
            "type": "new_bid",
            "title": "New Bid Placed",
            "description": "Demo Buyer placed a bid of PKR 1,250,000 on 4x Huawei Sun2000 Inverters.",
            "entity_id": "bid_demo_01",
            "entity_type": "bid",
            "is_read": False,
        },
        {
            "id": "admin_notif_04",
            "type": "lead",
            "title": "New Meta / Facebook Lead",
            "description": "Tariq Mehmood submitted scrap inquiry for 120x 350W panels (Karachi).",
            "entity_id": "lead_demo_01",
            "entity_type": "lead",
            "is_read": True,
        },
    ]
    for n in sample_admin_notifications:
        n_ref = db.collection("admin_notifications").document(n["id"])
        n_data = {**n, "created_at": firestore.SERVER_TIMESTAMP}
        n_ref.set(n_data, merge=True)
        print(f"[+] Seeded Admin Notification {n['id']} ({n['title']})")

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
