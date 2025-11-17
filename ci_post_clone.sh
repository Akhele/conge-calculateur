#!/bin/sh

# Xcode Cloud Post-Clone Script for Flutter iOS
# This script runs after the repository is cloned and before the build
# It ensures Flutter dependencies and CocoaPods are installed

set -e

echo "=========================================="
echo "🚀 Xcode Cloud Post-Clone Script Starting"
echo "=========================================="
echo "Timestamp: $(date)"
echo "Working Directory: $(pwd)"
echo "CI_WORKSPACE: ${CI_WORKSPACE:-not set}"
echo "=========================================="

# Get the repository root directory (Xcode Cloud provides CI_WORKSPACE)
REPO_ROOT="${CI_WORKSPACE:-$(pwd)}"
cd "${REPO_ROOT}"

echo "📁 Repository root: ${REPO_ROOT}"

# Check if Flutter is available
echo ""
echo "=========================================="
echo "🔍 Checking for Flutter"
echo "=========================================="

if ! command -v flutter &> /dev/null; then
    echo "⚠️ Flutter not found in PATH, searching..."
    
    # Try common Flutter installation paths
    FLUTTER_PATHS=(
        "${HOME}/flutter/bin"
        "${HOME}/development/flutter/bin"
        "/usr/local/flutter/bin"
        "/opt/flutter/bin"
        "/Applications/flutter/bin"
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
        echo "❌ ERROR: Flutter not found in standard locations"
        echo ""
        echo "Xcode Cloud may not have Flutter pre-installed."
        echo "You may need to:"
        echo "1. Install Flutter in Xcode Cloud environment, or"
        echo "2. Use a different CI/CD service like Codemagic that supports Flutter"
        echo ""
        echo "Attempting to continue anyway - build may fail..."
        # Don't exit - let's see if we can still build without Flutter
        # (though it will likely fail)
    fi
fi

# Verify Flutter is accessible
if command -v flutter &> /dev/null; then
    echo "✅ Flutter found: $(flutter --version | head -n 1)"
    
    # Navigate to project root
    cd "${REPO_ROOT}"
    
    # Get Flutter dependencies
    echo ""
    echo "=========================================="
    echo "📦 Installing Flutter dependencies"
    echo "=========================================="
    flutter pub get
    
    # Verify Generated.xcconfig was created
    if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
        echo "⚠️ Generated.xcconfig not found, attempting to regenerate..."
        flutter precache --ios
        flutter pub get
    fi
    
    if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
        echo "❌ ERROR: Failed to generate Generated.xcconfig"
        echo "Build will likely fail"
        exit 1
    fi
    
    echo "✅ Generated.xcconfig created"
else
    echo "⚠️ Flutter not available - skipping Flutter setup"
    echo "Build will likely fail if Generated.xcconfig is required"
fi

# Install CocoaPods dependencies
echo ""
echo "=========================================="
echo "🍫 Installing CocoaPods dependencies"
echo "=========================================="
cd "${REPO_ROOT}/ios"

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "⚠️ CocoaPods not found. Attempting to install..."
    # Try installing CocoaPods (may require sudo in some environments)
    if command -v gem &> /dev/null; then
        echo "Installing CocoaPods via gem..."
        gem install cocoapods || {
            echo "⚠️ Failed to install CocoaPods with gem, trying with sudo..."
            sudo gem install cocoapods || {
                echo "❌ ERROR: Failed to install CocoaPods"
                echo "CocoaPods should be pre-installed in Xcode Cloud"
                exit 1
            }
        }
    else
        echo "❌ ERROR: gem command not found. Cannot install CocoaPods."
        echo "CocoaPods should be pre-installed in Xcode Cloud"
        exit 1
    fi
fi

echo "✅ CocoaPods found: $(pod --version)"

# Show current directory
echo ""
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la | head -10

# Clean and install pods
echo ""
echo "🧹 Cleaning CocoaPods cache (if needed)..."
pod cache clean --all 2>/dev/null || echo "Cache clean skipped (not critical)"

echo ""
echo "📦 Running 'pod install'..."
echo "This may take a few minutes..."
pod install --repo-update

# Verify Pods directory exists
echo ""
echo "🔍 Verifying installation..."
if [ ! -d "Pods" ]; then
    echo "❌ ERROR: Pods directory not found after 'pod install'"
    echo "Listing ios directory contents:"
    ls -la
    exit 1
fi

echo "✅ Pods directory exists"

# List Pods directory structure
echo ""
echo "Pods directory structure:"
ls -la Pods/ | head -10
if [ -d "Pods/Target Support Files" ]; then
    echo "✅ Target Support Files directory exists"
    ls -la "Pods/Target Support Files/" | head -10
fi

# Verify required files exist
echo ""
echo "🔍 Verifying required .xcfilelist files..."

INPUT_FILE="Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-input-files.xcfilelist"
OUTPUT_FILE="Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-output-files.xcfilelist"

if [ ! -f "${INPUT_FILE}" ]; then
    echo "❌ ERROR: ${INPUT_FILE} not found"
    echo "Checking if Pods-Runner directory exists:"
    if [ -d "Pods/Target Support Files/Pods-Runner" ]; then
        echo "Pods-Runner directory contents:"
        ls -la "Pods/Target Support Files/Pods-Runner/"
    else
        echo "Pods-Runner directory does not exist"
        echo "Available targets:"
        ls -la "Pods/Target Support Files/" || echo "Target Support Files directory not found"
    fi
    exit 1
fi

if [ ! -f "${OUTPUT_FILE}" ]; then
    echo "❌ ERROR: ${OUTPUT_FILE} not found"
    exit 1
fi

echo "✅ ${INPUT_FILE} exists"
echo "✅ ${OUTPUT_FILE} exists"

# Show file contents for debugging
echo ""
echo "Input file contents (first 5 lines):"
head -5 "${INPUT_FILE}" || true

echo ""
echo "Output file contents (first 5 lines):"
head -5 "${OUTPUT_FILE}" || true

echo ""
echo "=========================================="
echo "✅ Post-clone setup completed successfully"
echo "=========================================="
echo "All required files verified and ready for build"
echo "=========================================="

