from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.firebase import init_firebase
from app.api.auth import router as auth_router
from app.api.storage import router as storage_router
from app.api.listings import router as listings_router
from app.api.notifications import router as notifications_router


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

# Configure CORS for Flutter Web, iOS, Android, and Desktop
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS if settings.CORS_ORIGINS != ["*"] else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API Routers
app.include_router(auth_router, prefix="/api/v1")
app.include_router(storage_router, prefix="/api/v1")
app.include_router(listings_router, prefix="/api/v1")
app.include_router(notifications_router, prefix="/api/v1")



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
