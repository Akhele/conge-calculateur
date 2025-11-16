# Xcode Update Guide

## Issue
Apple requires iOS 18 SDK (Xcode 16+) for App Store submissions. Xcode 15.2 includes iOS 17.2 SDK, which is no longer accepted.

## Solution: Update Xcode

### Method 1: Mac App Store (Recommended)

1. **Open Mac App Store**
   - Click the App Store icon in your dock
   - Or search Spotlight for "App Store"

2. **Search for Xcode**
   - Type "Xcode" in the search bar
   - Click on Xcode

3. **Update/Install**
   - If you see "Update" button, click it
   - If you see "Get" or "Install", click it
   - Wait for download and installation (this is a large file, 10-15 GB)

4. **Verify Installation**
   ```bash
   xcodebuild -version
   ```
   Should show Xcode 16.x or later

### Method 2: Apple Developer Website

1. **Visit Apple Developer Downloads**
   - Go to: https://developer.apple.com/download/all/
   - Sign in with your Apple Developer account

2. **Download Xcode**
   - Find Xcode 16.x or later
   - Click "Download"
   - Wait for download to complete

3. **Install**
   - Double-click the downloaded `.xip` file
   - Wait for extraction and installation
   - Move Xcode to Applications folder if needed

4. **Verify Installation**
   ```bash
   xcodebuild -version
   ```

### Method 3: Command Line (if you have mas-cli)

```bash
mas upgrade Xcode
```

## After Updating Xcode

### 1. Accept License Agreement
```bash
sudo xcodebuild -license accept
```

### 2. Install Command Line Tools
```bash
xcode-select --install
```

### 3. Clean and Rebuild

```bash
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur

# Clean Flutter build
flutter clean

# Get dependencies
flutter pub get

# Reinstall CocoaPods dependencies
cd ios
pod deintegrate
pod install
cd ..

# Rebuild iOS
flutter build ios --release --no-codesign
```

### 4. Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### 5. Verify SDK Version in Xcode

1. Select the **Runner** project
2. Select the **Runner** target
3. Go to **Build Settings**
4. Search for "iOS Deployment Target"
5. Verify it shows iOS 18.0 or later

### 6. Create Archive Again

1. Select **"Any iOS Device"** as build target
2. **Product → Archive**
3. Should now work without SDK version error

## Troubleshooting

### Xcode Not Updating

**Check macOS Version:**
- Xcode 16 requires macOS 14.5 (Sonoma) or later
- Check your macOS version: `sw_vers`

**If macOS is too old:**
- Update macOS first: System Settings → Software Update
- Then update Xcode

### Multiple Xcode Versions

If you have multiple Xcode versions:
```bash
# List installed versions
ls /Applications/ | grep Xcode

# Switch active Xcode version
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Verify
xcodebuild -version
```

### Build Errors After Update

1. **Clean Derived Data:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

2. **Reinstall Pods:**
   ```bash
   cd ios
   pod deintegrate
   pod install
   ```

3. **Rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release --no-codesign
   ```

## System Requirements

- **macOS**: 14.5 (Sonoma) or later for Xcode 16
- **RAM**: 8 GB minimum (16 GB recommended)
- **Storage**: 20+ GB free space
- **Internet**: Fast connection for download

## Verification Checklist

After updating, verify:
- [ ] Xcode version is 16.x or later (`xcodebuild -version`)
- [ ] License accepted (`sudo xcodebuild -license accept`)
- [ ] Command line tools installed (`xcode-select -p`)
- [ ] Flutter build succeeds (`flutter build ios --release --no-codesign`)
- [ ] Archive succeeds in Xcode (Product → Archive)
- [ ] No SDK version errors when uploading

## Additional Resources

- [Xcode Release Notes](https://developer.apple.com/documentation/xcode-release-notes)
- [Apple Developer Downloads](https://developer.apple.com/download/all/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

