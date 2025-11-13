# Release Preparation Guide

This guide will help you prepare your app for release on the App Store (iOS) and Play Store (Android).

## Prerequisites

- [ ] Flutter SDK installed and up to date
- [ ] Android Studio installed (for Android)
- [ ] Xcode installed (for iOS, macOS only)
- [ ] Developer accounts:
  - [ ] Google Play Console account ($25 one-time fee)
  - [ ] Apple Developer Program account ($99/year)

## Step 1: Update Version Numbers

The version is already set in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- `1.0.0` = version name (shown to users)
- `1` = version code/build number (internal, must increment for each release)

**For future releases**, increment:
- Patch: `1.0.1+2` (bug fixes)
- Minor: `1.1.0+3` (new features)
- Major: `2.0.0+4` (breaking changes)

## Step 2: Android Release Preparation

### 2.1 Update Application ID

The current application ID is `com.example.conge_calculateur`. **You MUST change this** before release:

1. Open `android/app/build.gradle.kts`
2. Change `applicationId` to your unique package name (e.g., `com.yourcompany.congecalculateur`)
3. Update `namespace` to match
4. Update package name in `MainActivity.kt`

### 2.2 Configure App Signing

#### Option A: Using Android App Bundle (Recommended)

1. Create a keystore file:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-your-keystore-file>
```

3. Update `android/app/build.gradle.kts` (already configured in this project)

#### Option B: Using Google Play App Signing (Easiest)

1. Upload your app to Play Console
2. Google will manage signing for you
3. You only need an upload key (follow Option A)

### 2.3 Build Release APK/AAB

```bash
# For App Bundle (recommended for Play Store):
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab

# For APK (for testing or direct distribution):
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### 2.4 Test Release Build

```bash
flutter install --release
```

## Step 3: iOS Release Preparation

### 3.1 Update Bundle Identifier

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities"
4. Change Bundle Identifier from `com.example.congeCalculateur` to your unique identifier (e.g., `com.yourcompany.congecalculateur`)

### 3.2 Configure Signing & Capabilities

1. In Xcode, select your development team
2. Enable "Automatically manage signing"
3. Ensure these capabilities are enabled:
   - Push Notifications (if using Firebase)
   - Background Modes → Remote notifications

### 3.3 Update App Icons and Launch Screen

1. **App Icons**: Add all required icon sizes in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
   - Required sizes: 20pt, 29pt, 40pt, 60pt, 76pt, 83.5pt (all @2x and @3x)
   - Use an icon generator tool or design manually

2. **Launch Screen**: Update `ios/Runner/Base.lproj/LaunchScreen.storyboard` if needed

### 3.4 Build for Release

```bash
# Build iOS app:
flutter build ios --release

# Then archive in Xcode:
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Product → Archive
# 3. Wait for archive to complete
# 4. Click "Distribute App"
# 5. Follow the wizard to upload to App Store Connect
```

## Step 4: App Store Listings

### 4.1 Google Play Store

**Required Information:**
- [ ] App name: "Congé calculateur"
- [ ] Short description (80 characters)
- [ ] Full description (4000 characters)
- [ ] App icon (512x512 PNG, no transparency)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (at least 2, up to 8):
  - Phone: 16:9 or 9:16, min 320px, max 3840px
  - Tablet: 16:9 or 9:16, min 320px, max 3840px
- [ ] Privacy Policy URL (required)
- [ ] Content rating questionnaire
- [ ] Target audience

**Categories:**
- Primary: Productivity / Utilities
- Secondary: (optional)

### 4.2 Apple App Store

**Required Information:**
- [ ] App name: "Congé calculateur"
- [ ] Subtitle (30 characters)
- [ ] Description (4000 characters)
- [ ] Keywords (100 characters, comma-separated)
- [ ] App icon (1024x1024 PNG, no transparency, no rounded corners)
- [ ] Screenshots:
  - iPhone 6.7": 1290x2796 or 2796x1290
  - iPhone 6.5": 1242x2688 or 2688x1242
  - iPhone 5.5": 1242x2208 or 2208x1242
  - iPad Pro 12.9": 2048x2732 or 2732x2048
- [ ] Privacy Policy URL (required)
- [ ] App Privacy details (data collection, tracking, etc.)

**Categories:**
- Primary: Productivity
- Secondary: Utilities

## Step 5: Privacy Policy

You **MUST** have a privacy policy URL before submitting to either store.

**What to include:**
- What data you collect (if any)
- How you use the data
- Third-party services (e.g., Calendarific API)
- User rights
- Contact information

**Options:**
1. Host on your website
2. Use a privacy policy generator
3. Use GitHub Pages (free)

Example services:
- [Privacy Policy Generator](https://www.privacypolicygenerator.info/)
- [Termly](https://termly.io/)

## Step 6: Pre-Submission Checklist

### Android (Play Store)
- [ ] App signed with release keystore
- [ ] Version code incremented
- [ ] Application ID changed from `com.example.*`
- [ ] App tested on multiple devices/Android versions
- [ ] No debug code or logging in release build
- [ ] App icon and screenshots prepared
- [ ] Privacy policy URL ready
- [ ] Content rating completed
- [ ] App bundle (.aab) built successfully

### iOS (App Store)
- [ ] Bundle identifier updated
- [ ] Signing configured with valid provisioning profile
- [ ] App icons added (all sizes)
- [ ] Launch screen configured
- [ ] Version and build number set
- [ ] App tested on physical device
- [ ] No debug code or logging
- [ ] App screenshots prepared (all required sizes)
- [ ] Privacy policy URL ready
- [ ] App Privacy details completed in App Store Connect
- [ ] Archive built successfully

## Step 7: Submission Process

### Google Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app
3. Fill in store listing
4. Upload app bundle (.aab file)
5. Complete content rating
6. Set pricing and distribution
7. Review and publish

**Review time:** Usually 1-3 days

### Apple App Store

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app
3. Fill in app information
4. Upload build via Xcode or Transporter
5. Complete App Privacy details
6. Submit for review

**Review time:** Usually 1-3 days (can be longer)

## Step 8: Post-Release

- [ ] Monitor crash reports
- [ ] Respond to user reviews
- [ ] Track analytics (if implemented)
- [ ] Plan updates and improvements

## Troubleshooting

### Android Issues

**Build fails:**
- Check `key.properties` file exists and is correct
- Verify keystore file path is correct
- Ensure Java version is compatible

**App crashes on release build:**
- Check ProGuard rules (if enabled)
- Verify all assets are included
- Test on multiple devices

### iOS Issues

**Signing errors:**
- Verify Apple Developer account is active
- Check provisioning profiles are valid
- Ensure Bundle ID matches in Xcode and App Store Connect

**Archive fails:**
- Clean build folder: `flutter clean`
- Delete DerivedData in Xcode
- Rebuild: `flutter build ios --release`

## Additional Resources

- [Flutter Release Documentation](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Flutter App Signing](https://docs.flutter.dev/deployment/android#signing-the-app)

## Support

For issues during release preparation, check:
1. Flutter documentation
2. Platform-specific documentation
3. Stack Overflow
4. Flutter GitHub issues

Good luck with your release! 🚀

