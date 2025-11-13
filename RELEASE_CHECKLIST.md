# Release Checklist

Use this checklist to ensure your app is ready for release.

## Pre-Release Setup

### Version & Configuration
- [ ] Version number updated in `pubspec.yaml` (currently: 1.0.0+1)
- [ ] Application ID changed from `com.example.*` to your unique ID
- [ ] Bundle identifier updated in iOS (Xcode)
- [ ] App name set to "Congé calculateur" (already done)

### Android Setup
- [ ] Keystore file created (`scripts/setup_android_signing.sh` or manually)
- [ ] `android/key.properties` file created with signing credentials
- [ ] Release build tested: `flutter build appbundle --release`
- [ ] APK tested on physical device: `flutter build apk --release`

### iOS Setup
- [ ] Xcode project opened: `open ios/Runner.xcworkspace`
- [ ] Bundle identifier updated in Xcode
- [ ] Signing configured with valid Apple Developer account
- [ ] App icons added (all required sizes)
- [ ] Launch screen configured
- [ ] Release build tested on physical device
- [ ] Archive created in Xcode

### Code Quality
- [ ] All debug logs removed or wrapped in `if (kDebugMode)`
- [ ] No test/example code left in production
- [ ] API keys secured (not hardcoded)
- [ ] Error handling implemented
- [ ] App tested on multiple devices/OS versions

### Assets
- [ ] App icon ready (1024x1024 for iOS, 512x512 for Android)
- [ ] Screenshots prepared for both stores
- [ ] Feature graphic ready (Android: 1024x500)
- [ ] Privacy policy URL ready and accessible

## Google Play Store

### Store Listing
- [ ] App name: "Congé calculateur"
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] App icon uploaded (512x512)
- [ ] Feature graphic uploaded (1024x500)
- [ ] Screenshots uploaded (at least 2)
- [ ] Privacy policy URL added
- [ ] Content rating completed
- [ ] Target audience set

### App Bundle
- [ ] App Bundle (.aab) uploaded
- [ ] Release notes added
- [ ] Release track selected (Internal/Alpha/Beta/Production)

## Apple App Store

### App Store Connect
- [ ] App name: "Congé calculateur"
- [ ] Subtitle added (30 chars)
- [ ] Description added (4000 chars)
- [ ] Keywords added (100 chars)
- [ ] App icon uploaded (1024x1024)
- [ ] Screenshots uploaded (all required sizes)
- [ ] Privacy policy URL added
- [ ] App Privacy details completed
- [ ] Pricing and availability set

### Build Upload
- [ ] Archive uploaded via Xcode
- [ ] Build selected for submission
- [ ] Export compliance completed (if required)

## Final Checks

- [ ] App tested on release build
- [ ] No crashes or critical bugs
- [ ] All features working correctly
- [ ] Performance acceptable
- [ ] Battery usage reasonable
- [ ] Network requests optimized
- [ ] Localization working (AR/FR/EN)

## Post-Submission

- [ ] Monitor app store reviews
- [ ] Respond to user feedback
- [ ] Track crash reports
- [ ] Monitor analytics (if implemented)
- [ ] Plan first update

## Quick Commands

```bash
# Build Android App Bundle
flutter build appbundle --release

# Build Android APK
flutter build apk --release

# Build iOS (then archive in Xcode)
flutter build ios --release

# Run release build locally
flutter run --release

# Clean build
flutter clean && flutter pub get
```

## Important Notes

⚠️ **Before First Release:**
1. Change `applicationId` in `android/app/build.gradle.kts`
2. Change Bundle ID in Xcode
3. Create and secure your keystore
4. Host your privacy policy
5. Prepare all store assets

🔒 **Security:**
- Never commit `key.properties` or keystore files
- Keep keystore backup in secure location
- Use environment variables for API keys

📱 **Testing:**
- Test on multiple devices
- Test on different OS versions
- Test with poor network conditions
- Test all app features

Good luck with your release! 🚀

