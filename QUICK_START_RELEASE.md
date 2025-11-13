# Quick Start: Preparing for Release

## 🚀 Quick Steps to Release

### 1. Android Release (15 minutes)

```bash
# Step 1: Set up signing (one-time)
cd android
bash ../scripts/setup_android_signing.sh
# OR manually create key.properties

# Step 2: Change Application ID (REQUIRED!)
# Edit android/app/build.gradle.kts
# Change: applicationId = "com.example.conge_calculateur"
# To: applicationId = "com.yourcompany.congecalculateur"

# Step 3: Build release
flutter build appbundle --release

# Step 4: Upload to Play Console
# File: build/app/outputs/bundle/release/app-release.aab
```

### 2. iOS Release (20 minutes)

```bash
# Step 1: Open in Xcode
open ios/Runner.xcworkspace

# Step 2: In Xcode:
# - Update Bundle Identifier
# - Configure Signing & Capabilities
# - Add app icons
# - Product → Archive

# Step 3: Upload to App Store Connect
# Follow Xcode wizard
```

### 3. Required Before Submission

- [ ] **Change Application ID** (Android) - CRITICAL!
- [ ] **Change Bundle ID** (iOS) - CRITICAL!
- [ ] **Create Privacy Policy** - REQUIRED by both stores
- [ ] **Prepare Screenshots** - Required for both stores
- [ ] **Test Release Builds** - Test on real devices

## 📋 Critical Checklist

### Must Do Before Release:

1. **Application IDs** ⚠️
   - Android: Change `com.example.conge_calculateur` in `build.gradle.kts`
   - iOS: Change Bundle ID in Xcode
   - **You cannot change these after first release!**

2. **Signing** 🔐
   - Android: Create keystore and `key.properties`
   - iOS: Configure in Xcode with Apple Developer account

3. **Privacy Policy** 📄
   - Create privacy policy (see `PRIVACY_POLICY_TEMPLATE.md`)
   - Host it online (GitHub Pages, your website, etc.)
   - Add URL to both store listings

4. **Assets** 🎨
   - App icons (1024x1024 iOS, 512x512 Android)
   - Screenshots (multiple sizes for iOS)
   - Feature graphic (Android: 1024x500)

5. **Testing** ✅
   - Test release builds on physical devices
   - Test all features
   - Test on different OS versions

## 🛠️ Build Commands

```bash
# Clean and prepare
flutter clean
flutter pub get

# Android
flutter build appbundle --release  # For Play Store
flutter build apk --release        # For testing

# iOS
flutter build ios --release        # Then archive in Xcode

# Or use the script
bash scripts/build_release.sh
```

## 📱 Store Submission

### Google Play Store
1. Go to [Play Console](https://play.google.com/console)
2. Create app → Fill store listing → Upload .aab
3. Complete content rating → Submit

### Apple App Store
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create app → Fill app information
3. Upload build via Xcode → Submit for review

## ⚠️ Important Notes

### Debug Logs
Your app currently has many `debugPrint()` statements. These are fine for release as `debugPrint` only outputs in debug mode. However, consider:
- Review logs before release
- Remove or wrap sensitive information
- Keep useful error logging

### Version Numbers
Current: `1.0.0+1` in `pubspec.yaml`
- First number = version name (user-facing)
- Second number = build number (increment for each release)

### Security
- ✅ `key.properties` is in `.gitignore`
- ✅ Keystore files are in `.gitignore`
- ⚠️ Keep keystore backup safe!
- ⚠️ Never commit signing credentials

## 📚 Full Documentation

- **Detailed Guide**: See `RELEASE_GUIDE.md`
- **Checklist**: See `RELEASE_CHECKLIST.md`
- **Privacy Policy**: See `PRIVACY_POLICY_TEMPLATE.md`

## 🆘 Need Help?

1. Check `RELEASE_GUIDE.md` for detailed instructions
2. Review Flutter deployment docs
3. Check platform-specific documentation
4. Test on multiple devices before submitting

Good luck! 🎉

