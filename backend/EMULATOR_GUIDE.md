# 🛠️ Solar Scrap Backend & Firebase Emulator Guide

This guide details how to run the Firebase Emulator suite, seed test accounts, start the FastAPI backend, and cleanly terminate all background services.

---

## 📋 Port Assignments

| Service | Port | Description |
| :--- | :--- | :--- |
| **FastAPI Backend** | `8000` | REST API Server (`http://localhost:8000` or `http://10.0.2.2:8000`) |
| **Firebase Auth Emulator** | `9099` | Local Firebase Authentication |
| **Firestore Emulator** | `8080` | Local Cloud Firestore Database |
| **Firebase Storage Emulator**| `9199` | Local Cloud Storage (Images/Media) |
| **Firebase Emulator UI** | `4000` | Web dashboard (`http://localhost:4000`) |
| **Firebase Hub / Logging** | `4400`, `4500` | Internal emulator control ports |

---

## 🚀 How to Run the Backend (Step-by-Step)

Navigate to the `backend/` directory:
```bash
cd backend
```

### Step 1: Start Firebase Emulator
Start the Auth, Firestore, and Storage emulators with the web UI enabled:
```bash
# If needed on macOS to ensure Java 21+ is in PATH:
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

firebase emulators:start --only auth,firestore,storage
```
> *The Emulator UI will be accessible at: [http://localhost:4000](http://localhost:4000)*

---

### Step 2: Seed Test Accounts (One-Time / Reset)
In a separate terminal tab (inside `backend/`), run the seed script:
```bash
./venv/bin/python seed_users.py
```

This creates the following credentials:

| Role | Email | Password |
| :--- | :--- | :--- |
| **Buyer** | `buyer@solarscrap.com` | `Password123!` |
| **Seller** | `seller@solarscrap.com` | `Password123!` |

---

### Step 3: Start the FastAPI Backend
In a separate terminal tab (inside `backend/`):
```bash
./venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
- Interactive Swagger API Docs: [http://localhost:8000/docs](http://localhost:8000/docs)
- Health Check: [http://localhost:8000/api/v1/health](http://localhost:8000/api/v1/health)

---

### 🔥 Step 4: Start EVERYTHING with One Command
If you want to start both the Firebase Emulator and FastAPI backend simultaneously in the same terminal, run this from the `backend/` directory:
```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"; firebase emulators:start --only auth,firestore,storage & ./venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
> *Note: Both services will share the same terminal output. To stop them, press `Ctrl+C` and use the kill command below if needed.*

---

## 🛑 How to Fully Kill All Services

If emulator ports remain occupied or processes hang in the background, use the following commands to cleanly terminate them.

### Option 1: Kill by Specific Ports (Recommended)
Kill all processes holding ports **8000, 9099, 8080, 4000, 4400, 4500**:
```bash
lsof -ti :8000,9099,8080,4000,4400,4500 | xargs kill -9 2>/dev/null || echo "Ports already clear"
```

### Option 2: Kill by Process Name
Terminate all Firebase and Uvicorn process instances:
```bash
pkill -9 -f "firebase" 2>/dev/null; pkill -9 -f "uvicorn" 2>/dev/null || echo "Processes stopped"
```

### Option 3: All-in-One Clean Reset Command
Copy-paste this single line in your terminal to completely wipe and free everything:
```bash
lsof -ti :8000,9099,8080,4000,4400,4500 | xargs kill -9 2>/dev/null; pkill -9 -f "firebase" 2>/dev/null; pkill -9 -f "uvicorn" 2>/dev/null; echo "✅ All Backend & Firebase Emulator services stopped."
```

---

## ☁️ Switching to Live Production Firebase

When you are ready to connect to production Firebase:

1. Open `backend/.env`.
2. Change `USE_EMULATOR=False`.
3. Add your `FIREBASE_PROJECT_ID` and `FIREBASE_WEB_API_KEY`.
4. Place your Google Service Account key in `backend/` and set:
   ```env
   FIREBASE_CREDENTIALS_PATH=./serviceAccountKey.json
   ```
5. Restart FastAPI:
   ```bash
   ./venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```
*No code modifications required.*


cd backend
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
firebase emulators:start --only auth,firestore & ./venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
