#!/bin/bash

# Complete Play Store Setup Script
# This script sets up everything needed to publish to Google Play Store

set -e

echo "🚀 Google Play Store Setup"
echo "=========================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if keystore exists
KEYSTORE_PATH="$HOME/upload-keystore.jks"
KEY_PROPERTIES="android/key.properties"

if [ -f "$KEYSTORE_PATH" ]; then
    echo -e "${YELLOW}⚠️  Keystore already exists at: $KEYSTORE_PATH${NC}"
    read -p "Do you want to create a new one? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Using existing keystore..."
        USE_EXISTING=true
    else
        USE_EXISTING=false
    fi
else
    USE_EXISTING=false
fi

# Step 1: Create keystore if needed
if [ "$USE_EXISTING" = false ]; then
    echo ""
    echo -e "${GREEN}Step 1: Creating release keystore...${NC}"
    echo ""
    echo "You'll be asked to enter:"
    echo "  - Keystore password (create a strong password)"
    echo "  - Key password (can be same as keystore password)"
    echo "  - Your name and organization info"
    echo ""
    read -p "Press Enter to continue..."
    echo ""
    
    keytool -genkey -v -keystore "$KEYSTORE_PATH" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Keystore created successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to create keystore${NC}"
        exit 1
    fi
fi

# Step 2: Get passwords for key.properties
echo ""
echo -e "${GREEN}Step 2: Setting up key.properties...${NC}"
echo ""

if [ -f "$KEY_PROPERTIES" ]; then
    echo -e "${YELLOW}⚠️  key.properties already exists${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing key.properties..."
        SKIP_PROPERTIES=true
    else
        SKIP_PROPERTIES=false
    fi
else
    SKIP_PROPERTIES=false
fi

if [ "$SKIP_PROPERTIES" = false ]; then
    echo "Enter the passwords you used when creating the keystore:"
    echo ""
    read -sp "Enter keystore password: " STORE_PASSWORD
    echo ""
    read -sp "Enter key password (press Enter if same as keystore): " KEY_PASSWORD
    echo ""
    
    # If key password is empty, use store password
    if [ -z "$KEY_PASSWORD" ]; then
        KEY_PASSWORD="$STORE_PASSWORD"
    fi
    
    # Create key.properties file
    cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=upload
storeFile=$KEYSTORE_PATH
EOF
    
    echo ""
    echo -e "${GREEN}✅ key.properties created!${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT: Keep your keystore and passwords safe!${NC}"
    echo "   Keystore location: $KEYSTORE_PATH"
    echo "   If you lose these, you cannot update your app!"
    echo ""
fi

# Step 3: Clean and rebuild
echo -e "${GREEN}Step 3: Cleaning and rebuilding app bundle...${NC}"
echo ""

cd "$(dirname "$0")"

flutter clean
echo ""
flutter pub get
echo ""
echo -e "${GREEN}Building release app bundle...${NC}"
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ App bundle built successfully!${NC}"
    echo ""
    BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$BUNDLE_PATH" ]; then
        SIZE=$(ls -lh "$BUNDLE_PATH" | awk '{print $5}')
        echo "📦 Bundle location: $(pwd)/$BUNDLE_PATH"
        echo "📦 Bundle size: $SIZE"
        echo ""
        echo -e "${GREEN}✅ Your app is ready to upload to Google Play Console!${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Go to https://play.google.com/console"
        echo "2. Create new app or select existing app"
        echo "3. Go to Production → Create new release"
        echo "4. Upload: $BUNDLE_PATH"
        echo ""
    else
        echo -e "${RED}❌ App bundle not found at expected location${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

# Step 4: Backup reminder
echo ""
echo -e "${YELLOW}📋 IMPORTANT REMINDERS:${NC}"
echo "1. Backup your keystore: cp $KEYSTORE_PATH ~/Desktop/upload-keystore-backup.jks"
echo "2. Store your passwords securely"
echo "3. The keystore file is required for all future updates"
echo ""

