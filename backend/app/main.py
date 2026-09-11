from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.firebase import init_firebase
from app.api.auth import router as auth_router
from app.api.storage import router as storage_router
from app.api.listings import router as listings_router
from app.api.notifications import router as notifications_router
from app.api.bids import router as bids_router
from app.api.admin import router as admin_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: initialize Firebase Admin SDK
    init_firebase()
    yield
    # Shutdown logic if any


app = FastAPI(
    title=settings.PROJECT_NAME,
    description="FastAPI Backend for Solar Scrap Marketplace (Buyer & Seller Portals)",
    version="1.0.0",
    lifespan=lifespan,
)

# Configure CORS for Next.js Website, Flutter Web, iOS, Android, and Desktop
explicit_origins = [o for o in settings.CORS_ORIGINS if o != "*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=explicit_origins if explicit_origins else ["*"],
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:[0-9]+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API Routers
app.include_router(auth_router, prefix="/api/v1")
app.include_router(storage_router, prefix="/api/v1")
app.include_router(listings_router, prefix="/api/v1")
app.include_router(notifications_router, prefix="/api/v1")
app.include_router(bids_router, prefix="/api/v1")
app.include_router(admin_router, prefix="/api/v1")



@app.get("/", tags=["Root"])
async def root():
    return {
        "app": settings.PROJECT_NAME,
        "environment": settings.ENV,
        "emulator_mode": settings.USE_EMULATOR,
        "status": "online",
        "docs_url": "/docs",
    }


@app.get("/api/v1/health", tags=["Health"])
async def health_check():
    return {
        "status": "healthy",
        "emulator_mode": settings.USE_EMULATOR,
        "firebase_project": settings.FIREBASE_PROJECT_ID,
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.BACKEND_HOST,
        port=settings.BACKEND_PORT,
        reload=True,
    )
