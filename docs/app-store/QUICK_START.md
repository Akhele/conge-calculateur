# App Store Quick Start Guide

Fast-track guide to get your app on the App Store quickly.

## Prerequisites Checklist

- [ ] Apple Developer Account ($99/year) - [Sign up](https://developer.apple.com)
- [ ] Xcode installed (you have Xcode 15.2 ✓)
- [ ] App Store Connect access
- [ ] App icon (1024x1024 PNG)
- [ ] Screenshots (at least 1 set)
- [ ] Privacy Policy URL

## Step 1: Configure Xcode (5 minutes)

```bash
# Open project in Xcode
open ios/Runner.xcworkspace
```

1. Select **Runner** target
2. Go to **"Signing & Capabilities"**
3. Select your **Team** (Apple Developer account)
4. Enable **"Automatically manage signing"**
5. Verify Bundle ID: `com.akhele.congecalculateur`

## Step 2: Build Release Archive (10-15 minutes)

```bash
# Clean and build
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur
flutter clean
flutter pub get
flutter build ios --release
```

Then in Xcode:
1. Select **"Any iOS Device"** (not simulator)
2. **Product → Archive**
3. Wait for archive to complete

## Step 3: Upload to App Store Connect (10-30 minutes)

In Xcode Organizer:
1. Select your archive
2. Click **"Distribute App"**
3. Choose **"App Store Connect"** → **"Upload"**
4. Select **"Automatically manage signing"**
5. Click **"Upload"**
6. Wait for upload to complete

## Step 4: Create App Listing (15-20 minutes)

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"My Apps"** → **"+"** → **"New App"**
3. Fill in:
   - **Name**: "Congé calculateur"
   - **Primary Language**: French
   - **Bundle ID**: `com.akhele.congecalculateur`
   - **SKU**: `congecalculateur-001`
4. Click **"Create"**

## Step 5: Complete App Information (20-30 minutes)

### App Privacy
- Answer: **No data collection, no tracking**

### App Store Listing
- **Name**: "Congé calculateur"
- **Subtitle**: "Calculateur de congés annuels"
- **Description**: (See full guide for template)
- **Keywords**: "congés, vacances, calcul, planning, travail"
- **Privacy Policy URL**: **REQUIRED**
- **Support URL**: Your website/GitHub

### Screenshots
- Upload at least 1 set of screenshots
- Minimum sizes: See full guide

### App Icon
- Upload 1024x1024 PNG icon

## Step 6: Select Build and Submit (5 minutes)

1. Wait for build processing (10-60 minutes)
2. Go to **"App Store"** tab → **"iOS App"**
3. Click **"+"** next to **"Build"**
4. Select your processed build
5. Complete export compliance:
   - **"Does your app use encryption?"** → **Yes**
   - **Explanation**: "Standard HTTPS encryption for API calls"
6. Click **"Submit for Review"**

## Step 7: Wait for Review

- **Typical wait**: 24-48 hours
- **Maximum**: Up to 7 days
- Check status in App Store Connect

## Common Issues & Quick Fixes

**"No signing certificate":**
- Ensure you're signed in to Xcode with Apple Developer account
- Check "Signing & Capabilities" tab

**"Bundle ID already exists":**
- Your bundle ID must be unique
- Current: `com.akhele.congecalculateur` (should be fine)

**"Missing privacy policy":**
- You MUST have a publicly accessible privacy policy URL
- Can host on GitHub Pages, your website, etc.

**"Invalid binary":**
- Ensure you built for release, not debug
- Check that all dependencies are included

## Need More Details?

See the complete guide: [APP_STORE_SUBMISSION.md](APP_STORE_SUBMISSION.md)

## Estimated Total Time

- **First time**: 2-3 hours (including waiting for build processing)
- **Subsequent releases**: 30-60 minutes

## Next Steps After Approval

1. Monitor downloads and reviews
2. Respond to user feedback
3. Plan updates and improvements
4. Consider App Store Optimization (ASO)

