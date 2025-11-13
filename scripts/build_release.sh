#!/bin/bash

# Build Release Script for Congé Calculateur
# This script builds release versions for both Android and iOS

set -e  # Exit on error

echo "🚀 Building release versions..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean

# Get dependencies
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
flutter pub get

# Build Android App Bundle (for Play Store)
echo -e "${GREEN}📱 Building Android App Bundle...${NC}"
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Android App Bundle built successfully!${NC}"
    echo -e "${GREEN}   Location: build/app/outputs/bundle/release/app-release.aab${NC}"
else
    echo -e "${RED}❌ Android App Bundle build failed${NC}"
    exit 1
fi

# Build Android APK (for testing)
echo -e "${GREEN}📱 Building Android APK...${NC}"
flutter build apk --release

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Android APK built successfully!${NC}"
    echo -e "${GREEN}   Location: build/app/outputs/flutter-apk/app-release.apk${NC}"
else
    echo -e "${RED}❌ Android APK build failed${NC}"
    exit 1
fi

# Build iOS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🍎 Building iOS app...${NC}"
    flutter build ios --release --no-codesign
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ iOS build completed!${NC}"
        echo -e "${YELLOW}   Note: You need to archive and sign in Xcode${NC}"
        echo -e "${YELLOW}   Open ios/Runner.xcworkspace in Xcode and Product → Archive${NC}"
    else
        echo -e "${RED}❌ iOS build failed${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Skipping iOS build (not on macOS)${NC}"
fi

echo -e "${GREEN}✨ All builds completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Test the release builds on physical devices"
echo "2. Upload Android App Bundle (.aab) to Google Play Console"
echo "3. Archive iOS app in Xcode and upload to App Store Connect"

