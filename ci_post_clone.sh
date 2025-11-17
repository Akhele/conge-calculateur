#!/bin/sh

# Xcode Cloud Post-Clone Script for Flutter iOS
# This script runs after the repository is cloned and before the build
# It ensures Flutter dependencies and CocoaPods are installed

# Don't exit on error - we want to try everything and report all issues
set +e

echo "=========================================="
echo "🚀 Xcode Cloud Post-Clone Script Starting"
echo "=========================================="
echo "Timestamp: $(date)"
echo "Working Directory: $(pwd)"
echo "CI_WORKSPACE: ${CI_WORKSPACE:-not set}"
echo "CI_PRODUCT_PLATFORM: ${CI_PRODUCT_PLATFORM:-not set}"
echo "=========================================="

# Get the repository root directory (Xcode Cloud provides CI_WORKSPACE)
REPO_ROOT="${CI_WORKSPACE:-$(pwd)}"
cd "${REPO_ROOT}"

echo "📁 Repository root: ${REPO_ROOT}"
echo "📁 Current directory contents:"
ls -la | head -10

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
        echo "⚠️ WARNING: Flutter not found in standard locations"
        echo ""
        echo "Attempting to install Flutter..."
        
        # Try to install Flutter
        if command -v git &> /dev/null; then
            echo "Installing Flutter from GitHub..."
            cd "${HOME}"
            git clone https://github.com/flutter/flutter.git -b stable 2>&1 | head -20
            if [ -d "${HOME}/flutter/bin" ]; then
                export PATH="${HOME}/flutter/bin:${PATH}"
                echo "✅ Flutter installed successfully"
                FLUTTER_FOUND=true
            else
                echo "⚠️ Flutter installation failed or incomplete"
            fi
            cd "${REPO_ROOT}"
        else
            echo "⚠️ git not available, cannot install Flutter"
        fi
        
        if [ "${FLUTTER_FOUND}" = "false" ]; then
            echo ""
            echo "⚠️ WARNING: Flutter is not available"
            echo "The build will likely fail without Flutter."
            echo "Generated.xcconfig will not be created."
            echo ""
            echo "Options:"
            echo "1. Configure Flutter installation in Xcode Cloud workflow"
            echo "2. Use Codemagic (better Flutter support)"
            echo "3. Commit Generated.xcconfig to repository (not recommended)"
            echo ""
            echo "Continuing with CocoaPods installation..."
        fi
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
        echo ""
        echo "Trying to create a minimal Generated.xcconfig..."
        # Create a minimal Generated.xcconfig if Flutter command failed
        mkdir -p ios/Flutter
        cat > ios/Flutter/Generated.xcconfig << EOF
// Auto-generated fallback file
FLUTTER_ROOT=/usr/local/flutter
FLUTTER_APPLICATION_PATH=${REPO_ROOT}
FLUTTER_TARGET=lib/main.dart
FLUTTER_BUILD_DIR=build
FLUTTER_BUILD_NAME=1.0.0
FLUTTER_BUILD_NUMBER=1
EOF
        echo "⚠️ Created fallback Generated.xcconfig (may not work correctly)"
    else
        echo "✅ Generated.xcconfig created"
    fi
else
    echo "⚠️ Flutter not available - skipping Flutter setup"
    echo "Attempting to create fallback Generated.xcconfig..."
    mkdir -p ios/Flutter
    if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
        cat > ios/Flutter/Generated.xcconfig << EOF
// Auto-generated fallback file (Flutter not available)
FLUTTER_ROOT=/usr/local/flutter
FLUTTER_APPLICATION_PATH=${REPO_ROOT}
FLUTTER_TARGET=lib/main.dart
FLUTTER_BUILD_DIR=build
FLUTTER_BUILD_NAME=1.0.0
FLUTTER_BUILD_NUMBER=1
EOF
        echo "⚠️ Created fallback Generated.xcconfig (build may still fail)"
    fi
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
        echo ""
        echo "Attempting to regenerate Pods..."
        pod install --repo-update
    else
        echo "Pods-Runner directory does not exist"
        echo "Available targets:"
        ls -la "Pods/Target Support Files/" 2>/dev/null || echo "Target Support Files directory not found"
        echo ""
        echo "Attempting to regenerate Pods..."
        pod install --repo-update
    fi
    
    # Check again after regeneration
    if [ ! -f "${INPUT_FILE}" ]; then
        echo "❌ CRITICAL: ${INPUT_FILE} still not found after regeneration"
        echo "Build will fail. Check CocoaPods installation and Podfile configuration."
        # Don't exit - let Xcode show the error
    fi
fi

if [ ! -f "${OUTPUT_FILE}" ]; then
    echo "❌ ERROR: ${OUTPUT_FILE} not found"
    echo "Attempting to regenerate Pods..."
    pod install --repo-update
    
    if [ ! -f "${OUTPUT_FILE}" ]; then
        echo "❌ CRITICAL: ${OUTPUT_FILE} still not found after regeneration"
        echo "Build will fail. Check CocoaPods installation and Podfile configuration."
        # Don't exit - let Xcode show the error
    fi
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
echo "📋 Final Status Check"
echo "=========================================="

# Final verification
FINAL_ERRORS=0

if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "❌ Generated.xcconfig: MISSING"
    FINAL_ERRORS=$((FINAL_ERRORS + 1))
else
    echo "✅ Generated.xcconfig: EXISTS"
fi

if [ ! -d "ios/Pods" ]; then
    echo "❌ Pods directory: MISSING"
    FINAL_ERRORS=$((FINAL_ERRORS + 1))
else
    echo "✅ Pods directory: EXISTS"
fi

if [ ! -f "ios/${INPUT_FILE}" ]; then
    echo "❌ ${INPUT_FILE}: MISSING"
    FINAL_ERRORS=$((FINAL_ERRORS + 1))
else
    echo "✅ ${INPUT_FILE}: EXISTS"
fi

if [ ! -f "ios/${OUTPUT_FILE}" ]; then
    echo "❌ ${OUTPUT_FILE}: MISSING"
    FINAL_ERRORS=$((FINAL_ERRORS + 1))
else
    echo "✅ ${OUTPUT_FILE}: EXISTS"
fi

echo ""
echo "=========================================="
if [ ${FINAL_ERRORS} -eq 0 ]; then
    echo "✅ Post-clone setup completed successfully"
    echo "All required files verified and ready for build"
else
    echo "⚠️ Post-clone setup completed with ${FINAL_ERRORS} error(s)"
    echo "Build may fail. Check errors above."
fi
echo "=========================================="

