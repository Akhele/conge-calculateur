#!/bin/bash

# Android Signing Setup Script
# This script helps you set up Android app signing for release

set -e

echo "🔐 Android Signing Setup"
echo "========================"
echo ""

# Check if key.properties already exists
if [ -f "android/key.properties" ]; then
    echo "⚠️  key.properties already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Get keystore path
read -p "Enter path for keystore file (default: ~/upload-keystore.jks): " KEYSTORE_PATH
KEYSTORE_PATH=${KEYSTORE_PATH:-~/upload-keystore.jks}

# Check if keystore exists
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo ""
    echo "📝 Keystore file not found. Let's create one!"
    read -p "Enter keystore password: " -s STORE_PASSWORD
    echo
    read -p "Enter key password (can be same as keystore): " -s KEY_PASSWORD
    echo
    read -p "Enter key alias (default: upload): " KEY_ALIAS
    KEY_ALIAS=${KEY_ALIAS:-upload}
    
    echo ""
    echo "Creating keystore..."
    keytool -genkey -v -keystore "$KEYSTORE_PATH" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias "$KEY_ALIAS" \
        -storepass "$STORE_PASSWORD" \
        -keypass "$KEY_PASSWORD" \
        -dname "CN=Congé Calculateur, OU=Development, O=Your Company, L=City, ST=State, C=MA"
    
    if [ $? -eq 0 ]; then
        echo "✅ Keystore created successfully!"
    else
        echo "❌ Failed to create keystore"
        exit 1
    fi
else
    echo "✅ Keystore file found: $KEYSTORE_PATH"
    read -p "Enter keystore password: " -s STORE_PASSWORD
    echo
    read -p "Enter key password: " -s KEY_PASSWORD
    echo
    read -p "Enter key alias (default: upload): " KEY_ALIAS
    KEY_ALIAS=${KEY_ALIAS:-upload}
fi

# Convert to absolute path
KEYSTORE_PATH=$(cd "$(dirname "$KEYSTORE_PATH")" && pwd)/$(basename "$KEYSTORE_PATH")

# Create key.properties file
cat > android/key.properties << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_PATH
EOF

echo ""
echo "✅ key.properties created successfully!"
echo ""
echo "⚠️  IMPORTANT:"
echo "   - Keep your keystore file safe and backed up!"
echo "   - If you lose it, you won't be able to update your app on Play Store"
echo "   - The key.properties file is already in .gitignore"
echo ""
echo "You can now build release versions with:"
echo "  flutter build appbundle --release"
echo "  flutter build apk --release"

