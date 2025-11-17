# App Store Connect Upload Readiness Checklist

## ✅ Code Configuration (VERIFIED)

- [x] **codemagic.yaml** exists and is configured
  - iOS workflow defined ✓
  - Bundle ID: `com.akhele.congecalculateur` ✓
  - ExportOptions.plist referenced ✓
  - App Store Connect publishing configured ✓

- [x] **ExportOptions.plist** configured correctly
  - Method: `app-store` ✓
  - Signing style: `automatic` ✓
  - Upload symbols: `true` ✓

- [x] **pubspec.yaml** version set
  - Version: `1.0.0+2` ✓
  - Build number increments automatically ✓

- [x] **Info.plist** configured
  - Display name: "Congé calculateur" ✓
  - Bundle identifier configured ✓
  - LSApplicationQueriesSchemes set ✓

## ⚠️ REQUIRED: Codemagic Setup

### 1. App Store Connect API Key
- [ ] **API Key created in App Store Connect**
  - Go to: [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → Users and Access → Keys
  - Create new API key with **App Manager** or **Admin** access
  - **Download the .p8 file immediately** (can only download once!)
  - Note the **Key ID** and **Issuer ID**

- [ ] **API Key added to Codemagic**
  - Go to: Codemagic Dashboard → Teams → Integrations → App Store Connect
  - Upload the .p8 file
  - Enter Key ID and Issuer ID
  - Save

- [ ] **API Key added to credentials group**
  - Go to: Codemagic → Teams → Groups
  - Create group: `app_store_credentials` (if not exists)
  - Add the API key to this group
  - Verify `codemagic.yaml` references this group: ✓ (already configured)

### 2. Code Signing Configuration
- [ ] **Code signing configured in Codemagic UI** (RECOMMENDED)
  - Go to: Your app in Codemagic → Code signing settings
  - Set distribution type to **"App Store"** (not "Development")
  - Enable automatic code signing
  - Save

  **OR**

- [ ] **Verify YAML code signing scripts**
  - Check that `xcode-project use-profiles --type IOS_APP_STORE` is in scripts ✓
  - This is already in your codemagic.yaml ✓

## ⚠️ REQUIRED: App Store Connect Setup

### 3. App Created in App Store Connect
- [ ] **App listing created**
  - Go to: [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → My Apps → "+" → New App
  - Platform: **iOS**
  - Name: **"Congé calculateur"**
  - Primary Language: **French** (or your preference)
  - Bundle ID: **`com.akhele.congecalculateur`**
  - SKU: Unique identifier (e.g., `congecalculateur-001`)
  - Click **"Create"**

### 4. App Store Listing Information
- [ ] **App Privacy configured**
  - Go to: App Store Connect → Your App → App Privacy
  - Answer: **No data collection, no tracking**
  - Save

- [ ] **App Store listing filled out**
  - Go to: App Store Connect → Your App → App Store → iOS App
  - **Name**: "Congé calculateur" (30 chars max)
  - **Subtitle**: "Calculateur de congés annuels" (30 chars max)
  - **Description**: Use content from `GOOGLE_PLAY_DESCRIPTION_FR.txt` (4000 chars max)
  - **Keywords**: "congés, vacances, calcul, planning, travail, douanes" (100 chars max)
  - **Privacy Policy URL**: **REQUIRED** - Must be publicly accessible
  - **Support URL**: Your website or GitHub repo
  - **Marketing URL** (optional): Your website

- [ ] **App Icon uploaded**
  - Size: 1024x1024 PNG
  - No transparency, no rounded corners
  - Upload in App Store Connect → App Store → iOS App → App Icon

- [ ] **Screenshots uploaded** (REQUIRED)
  - At least 1 set of screenshots for one device family
  - Minimum sizes:
    - iPhone 6.7": 1290 x 2796 pixels (portrait)
    - iPhone 6.5": 1242 x 2688 pixels (portrait)
    - iPhone 5.5": 1242 x 2208 pixels (portrait)
  - Upload in App Store Connect → App Store → iOS App → Screenshots

- [ ] **Version information**
  - **What's New**: "Version initiale de l'application. Calcul des congés annuels avec gestion automatique des week-ends et jours fériés."
  - **Version Release**: Choose "Manual" for first release

## ⚠️ REQUIRED: Privacy Policy

- [ ] **Privacy Policy URL created**
  - Must be publicly accessible (not behind authentication)
  - Can host on:
    - GitHub Pages
    - Your website
    - Any public URL
  - Content should state: No data collection, no tracking, no ads
  - See: `docs/play-store/PRIVACY_POLICY_TEMPLATE.md` for template

## 📋 Pre-Build Checklist

Before triggering Codemagic build:

- [ ] All items above are completed
- [ ] Git repository is connected to Codemagic
- [ ] Branch to build is selected (usually `main` or `master`)
- [ ] Codemagic has access to your repository

## 🚀 Build Configuration

### Current codemagic.yaml Status:

✅ **iOS Workflow**: Configured
✅ **App Store Connect Publishing**: Configured
✅ **Submit to TestFlight**: `false` (set to `true` if you want TestFlight)
✅ **Submit to App Store**: Commented out (uncomment when ready)

### To Enable Automatic Submission:

Edit `codemagic.yaml` line 80:
```yaml
# Change from:
submit_to_testflight: false

# To:
submit_to_testflight: true  # For TestFlight testing
# OR
submit_to_app_store: true   # For direct App Store submission
```

## ⚠️ Common Issues to Avoid

1. **"Failed to fetch iOS signing files"**
   - ✅ Fix: Ensure API key is added to Codemagic and `app_store_credentials` group

2. **"Invalid Provisioning Profile"**
   - ✅ Fix: Configure code signing in Codemagic UI to use "App Store" distribution type

3. **"Missing privacy policy"**
   - ✅ Fix: Add Privacy Policy URL in App Store Connect listing

4. **"No build selected"**
   - ✅ Fix: Wait for build to process (10-60 minutes), then select it in App Store Connect

5. **"Invalid binary"**
   - ✅ Fix: Ensure ExportOptions.plist method is "app-store" (already configured ✓)

## ✅ Ready to Build?

**Answer: NOT YET** - Complete the following first:

1. ⚠️ **App Store Connect API Key** - Must be created and added to Codemagic
2. ⚠️ **App created in App Store Connect** - Must exist before upload
3. ⚠️ **Privacy Policy URL** - Required for submission
4. ⚠️ **App Store listing information** - At minimum: description, privacy policy URL
5. ⚠️ **Screenshots** - At least 1 set required
6. ⚠️ **App Icon** - 1024x1024 PNG required

## 🎯 Quick Start Steps

1. **Create App Store Connect API Key** (5 minutes)
   - Follow: `docs/app-store/CODEMAGIC_SETUP.md` Step 1

2. **Add API Key to Codemagic** (5 minutes)
   - Follow: `docs/app-store/CODEMAGIC_SETUP.md` Step 2

3. **Create App in App Store Connect** (10 minutes)
   - Follow: `docs/app-store/APP_STORE_SUBMISSION.md` Step 6.1

4. **Complete App Store Listing** (20 minutes)
   - Add description from `GOOGLE_PLAY_DESCRIPTION_FR.txt`
   - Add privacy policy URL
   - Upload screenshots and app icon

5. **Trigger Codemagic Build** (10-20 minutes)
   - Go to Codemagic dashboard
   - Select iOS workflow
   - Start build

6. **Select Build in App Store Connect** (after processing)
   - Wait 10-60 minutes for build to process
   - Select build in App Store Connect
   - Submit for review

## 📝 Notes

- The code is **ready** - all configuration files are correct ✓
- You need to complete the **Codemagic and App Store Connect setup** first
- Once setup is complete, Codemagic can automatically build and upload
- First build may take longer due to processing time
- Review typically takes 24-48 hours

## 📚 Reference Documents

- **Codemagic Setup**: `docs/app-store/CODEMAGIC_SETUP.md`
- **App Store Submission**: `docs/app-store/APP_STORE_SUBMISSION.md`
- **Quick Start**: `docs/app-store/QUICK_START.md`
- **French Description**: `GOOGLE_PLAY_DESCRIPTION_FR.txt`
- **Privacy Policy Template**: `docs/play-store/PRIVACY_POLICY_TEMPLATE.md`

