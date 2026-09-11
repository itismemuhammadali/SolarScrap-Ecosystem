# Solar Scrap Workspace

Monorepo workspace containing the mobile app, web application, and backend service for Solar Scrap.

## Repository Structure

- **`solar_scrap_app/`**: Flutter mobile application (iOS & Android).
- **`website_main/`**: Next.js web application.
- **`backend/`**: FastAPI backend service supporting both mobile and web clients.

## Quick Start

### Flutter Mobile App
```bash
cd solar_scrap_app
flutter pub get
flutter run
```

### Web Application
```bash
cd website_main
npm install
npm run dev
```

### Backend Service
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
