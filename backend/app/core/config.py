import os
from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    PROJECT_NAME: str = "Solar Scrap API"
    ENV: str = "development"

    # Emulator Settings
    USE_EMULATOR: bool = True
    FIREBASE_PROJECT_ID: str = "solar-scrap-demo"
    FIREBASE_AUTH_EMULATOR_HOST: str = "localhost:9099"
    FIRESTORE_EMULATOR_HOST: str = "localhost:8080"
    FIREBASE_STORAGE_EMULATOR_HOST: str = "localhost:9199"
    FIREBASE_STORAGE_BUCKET: str = "solar-scrap-demo.appspot.com"

    # Production Firebase Settings
    FIREBASE_CREDENTIALS_PATH: str = ""
    FIREBASE_WEB_API_KEY: str = ""

    # Server Settings
    BACKEND_HOST: str = "0.0.0.0"
    BACKEND_PORT: int = 8000
    CORS_ORIGINS: List[str] = ["*"]

    model_config = SettingsConfigDict(
        env_file=os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )


settings = Settings()
