# Xcode Cloud Setup for Flutter iOS

This guide explains how to configure Xcode Cloud to build Flutter iOS apps.

## Problem

Xcode Cloud builds fail with errors like:
- `could not find included file 'Generated.xcconfig'`
- `Unable to load contents of file list: Pods-Runner-frameworks-Release-input-files.xcfilelist`

## Solution

A pre-build script (`ci_scripts/ci_pre_xcodebuild.sh`) has been added to automatically:
1. Generate Flutter configuration files (`Generated.xcconfig`)
2. Install CocoaPods dependencies
3. Verify all required files are present

## How It Works

Xcode Cloud automatically runs scripts in the `ci_scripts/` directory:
- Scripts starting with `ci_pre_` run **before** the build
- Scripts starting with `ci_post_` run **after** the build

The script `ci_pre_xcodebuild.sh` runs before Xcode builds and ensures all Flutter dependencies are ready.

## Prerequisites

### 1. Flutter Installation in Xcode Cloud

Xcode Cloud needs Flutter to be available. You have two options:

#### Option A: Install Flutter in Pre-Build Script (Recommended)
The script will attempt to find Flutter in common locations. If Flutter is not found, you may need to install it.

#### Option B: Configure Flutter in Xcode Cloud Workflow
1. Go to Xcode Cloud dashboard
2. Select your workflow
3. Add a custom environment variable or install script for Flutter

### 2. CocoaPods
CocoaPods should be available in Xcode Cloud environment. The script will attempt to install it if missing.

## Configuration Steps

### Step 1: Verify Script is Committed
Ensure `ci_scripts/ci_pre_xcodebuild.sh` is committed to your repository:
```bash
git add ci_scripts/ci_pre_xcodebuild.sh
git commit -m "Add Xcode Cloud pre-build script"
git push
```

### Step 2: Configure Xcode Cloud Workflow

1. **Go to Xcode Cloud Dashboard:**
   - Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Navigate to your app → Xcode Cloud

2. **Select Your Workflow:**
   - Click on the workflow that's failing
   - Or create a new workflow

3. **Verify Build Settings:**
   - Ensure the workflow is configured for iOS
   - Check that the correct scheme (`Runner`) is selected
   - Verify the correct branch is being built

4. **Add Flutter Installation (if needed):**
   - If Flutter is not pre-installed, add a custom script or environment setup
   - Or ensure Flutter is available in the build environment

### Step 3: Test the Build

1. **Trigger a Build:**
   - Push a commit to trigger Xcode Cloud
   - Or manually start a build from Xcode Cloud dashboard

2. **Check Build Logs:**
   - Look for the pre-build script output
   - Verify it shows:
     - ✅ Flutter found
     - ✅ Generated.xcconfig created
     - ✅ CocoaPods dependencies installed

## Troubleshooting

### Error: "Flutter not found"

**Solution:**
- Ensure Flutter is installed in the Xcode Cloud environment
- Check if Flutter needs to be added to PATH
- Consider installing Flutter in the pre-build script if not available

### Error: "CocoaPods not found"

**Solution:**
- The script will attempt to install CocoaPods automatically
- If installation fails, ensure `gem` is available
- You may need to configure CocoaPods installation in Xcode Cloud settings

### Error: "Generated.xcconfig not found"

**Solution:**
- Verify `flutter pub get` runs successfully
- Check build logs for Flutter errors
- Ensure Flutter is properly configured

### Error: "Pods directory not found"

**Solution:**
- Verify `pod install` runs successfully
- Check build logs for CocoaPods errors
- Ensure CocoaPods is properly installed

## Script Details

The pre-build script (`ci_scripts/ci_pre_xcodebuild.sh`) performs:

1. **Flutter Setup:**
   - Finds Flutter in common installation paths
   - Verifies Flutter is accessible
   - Runs `flutter pub get` to generate configuration files

2. **CocoaPods Setup:**
   - Checks if CocoaPods is installed
   - Installs CocoaPods if missing
   - Runs `pod install` to install dependencies

3. **Verification:**
   - Verifies `Generated.xcconfig` exists
   - Verifies Pods directory exists
   - Verifies required `.xcfilelist` files exist

## Alternative: Manual Flutter Installation

If Flutter is not available in Xcode Cloud, you can add Flutter installation to the script:

```bash
# Add to ci_pre_xcodebuild.sh before Flutter check
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable ~/flutter
    export PATH="$HOME/flutter/bin:$PATH"
fi
```

**Note:** This will increase build time significantly. It's better to have Flutter pre-installed.

## Verification

After setting up, verify the build succeeds:

1. Check build logs for:
   ```
   ✅ Flutter found: Flutter 3.x.x
   ✅ Generated.xcconfig created
   ✅ CocoaPods dependencies installed
   ✅ All required files verified
   ✅ Pre-build setup completed successfully
   ```

2. The Xcode build should proceed without errors about missing files.

## Next Steps

Once the build succeeds:
1. Configure code signing for App Store distribution
2. Set up automatic upload to App Store Connect
3. Configure TestFlight distribution (optional)

## Related Documentation

- [App Store Submission Guide](APP_STORE_SUBMISSION.md)
- [Codemagic Setup Guide](CODEMAGIC_SETUP.md)
- [Xcode Cloud Documentation](https://developer.apple.com/documentation/xcode)

