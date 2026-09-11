#!/bin/bash
# =============================================================================
# Solar Scrap - Seed Test Users to Firebase Emulator
# =============================================================================
# This script injects the test accounts (Admin, Buyer, Seller) into the
# running Firebase Emulator Auth & Firestore database.
#
# Usage:
#   ./seed_emulator.sh
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"

if [ ! -d "$BACKEND_DIR/venv" ]; then
    echo "❌ Error: Virtual environment not found in $BACKEND_DIR/venv"
    exit 1
fi

echo "🚀 Seeding test credentials to Firebase Emulator..."
cd "$BACKEND_DIR"
./venv/bin/python seed_users.py
