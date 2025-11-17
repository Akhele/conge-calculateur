#!/bin/sh

# Xcode Cloud Pre-Build Script for Flutter iOS
# This script runs before Xcode builds the project
# It ensures Flutter dependencies and CocoaPods are installed

set -e

echo "🚀 Starting Flutter pre-build setup..."

# Get the repository root directory (Xcode Cloud provides CI_WORKSPACE)
REPO_ROOT="${CI_WORKSPACE:-$(pwd)}"
cd "${REPO_ROOT}"

echo "📁 Working directory: ${REPO_ROOT}"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "⚠️ Flutter not found in PATH, searching..."
    
    # Try common Flutter installation paths
    FLUTTER_PATHS=(
        "${HOME}/flutter/bin"
        "${HOME}/development/flutter/bin"
        "/usr/local/flutter/bin"
        "/opt/flutter/bin"
    )
    
    FLUTTER_FOUND=false
    for path in "${FLUTTER_PATHS[@]}"; do
        if [ -d "${path}" ] && [ -f "${path}/flutter" ]; then
            export PATH="${path}:${PATH}"
            echo "✅ Found Flutter at: ${path}"
            FLUTTER_FOUND=true
            break
        fi
    done
    
    if [ "${FLUTTER_FOUND}" = "false" ]; then
        echo "❌ Flutter not found in standard locations"
        echo "Please ensure Flutter is installed in Xcode Cloud environment"
        exit 1
    fi
fi

# Verify Flutter is accessible
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter command still not accessible"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Navigate to project root
cd "${REPO_ROOT}"

# Get Flutter dependencies
echo "📦 Running 'flutter pub get'..."
flutter pub get

# Verify Generated.xcconfig was created
if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "❌ Generated.xcconfig not found after 'flutter pub get'"
    echo "Attempting to regenerate..."
    flutter precache --ios
    flutter pub get
fi

if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "❌ Failed to generate Generated.xcconfig"
    exit 1
fi

echo "✅ Generated.xcconfig created"

# Install CocoaPods dependencies
echo "🍫 Installing CocoaPods dependencies..."
cd ios

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "⚠️ CocoaPods not found. Attempting to install..."
    # Try installing CocoaPods (may require sudo in some environments)
    if command -v gem &> /dev/null; then
        gem install cocoapods || {
            echo "⚠️ Failed to install CocoaPods with gem, trying with sudo..."
            sudo gem install cocoapods || {
                echo "❌ Failed to install CocoaPods"
                exit 1
            }
        }
    else
        echo "❌ gem command not found. Cannot install CocoaPods."
        exit 1
    fi
fi

echo "✅ CocoaPods found: $(pod --version)"

# Clean and install pods
echo "🧹 Cleaning CocoaPods cache..."
pod cache clean --all 2>/dev/null || true

echo "📦 Running 'pod install'..."
pod install --repo-update

# Verify Pods directory exists
if [ ! -d "Pods" ]; then
    echo "❌ Pods directory not found after 'pod install'"
    exit 1
fi

echo "✅ CocoaPods dependencies installed"

# Verify required files exist
echo "🔍 Verifying required files..."

if [ ! -f "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-input-files.xcfilelist" ]; then
    echo "❌ Pods-Runner-frameworks-Release-input-files.xcfilelist not found"
    exit 1
fi

if [ ! -f "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-output-files.xcfilelist" ]; then
    echo "❌ Pods-Runner-frameworks-Release-output-files.xcfilelist not found"
    exit 1
fi

echo "✅ All required files verified"
echo "✅ Pre-build setup completed successfully"

