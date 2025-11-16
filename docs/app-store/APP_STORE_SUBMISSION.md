# App Store Submission Guide

Complete guide for submitting your app to the Apple App Store.

## Build Methods

This guide covers manual submission using Xcode. For automated CI/CD builds, see:
- **[Codemagic Setup Guide](CODEMAGIC_SETUP.md)** - Automated builds and App Store uploads using Codemagic

## Prerequisites

- [ ] **Apple Developer Account** ($99/year)
  - Sign up at [developer.apple.com](https://developer.apple.com)
  - Enroll in the Apple Developer Program
- [ ] **Xcode** installed (you have Xcode 15.2 ✓)
- [ ] **App Store Connect** access
  - Access at [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- [ ] **App icons** prepared (1024x1024 PNG)
- [ ] **Screenshots** prepared for different device sizes
- [ ] **Privacy Policy URL** (required)

## Step 1: Verify iOS Configuration

### 1.1 Bundle Identifier
Your bundle ID is already set: `com.akhele.congecalculateur` ✓

### 1.2 App Version
Current version in `pubspec.yaml`: `1.0.0+2`
- Version name: `1.0.0` (shown to users)
- Build number: `2` (increments with each submission)

### 1.3 Info.plist Configuration
Verify these settings in `ios/Runner/Info.plist`:
- ✅ `CFBundleDisplayName`: "Congé calculateur"
- ✅ `LSApplicationQueriesSchemes`: mailto, tel, sms
- ✅ Privacy descriptions (if needed)

## Step 2: Configure Signing in Xcode

1. **Open the project in Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select the Runner target:**
   - Click on "Runner" in the project navigator
   - Select the "Runner" target (not the project)

3. **Go to "Signing & Capabilities" tab:**
   - Select your **Team** (your Apple Developer account)
   - Enable **"Automatically manage signing"**
   - Verify Bundle Identifier: `com.akhele.congecalculateur`

4. **Check Capabilities:**
   - No special capabilities needed for this app
   - If you add features later (push notifications, etc.), add them here

## Step 3: Prepare App Assets

### 3.1 App Icon (Required)
- **Size**: 1024x1024 pixels
- **Format**: PNG (no transparency, no rounded corners)
- **Location**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **Note**: Xcode will generate all sizes from the 1024x1024 icon

### 3.2 Screenshots (Required)
You need screenshots for at least one device family:

**iPhone 6.7" Display (iPhone 14 Pro Max, 15 Pro Max):**
- Portrait: 1290 x 2796 pixels
- Landscape: 2796 x 1290 pixels

**iPhone 6.5" Display (iPhone 11 Pro Max, XS Max):**
- Portrait: 1242 x 2688 pixels
- Landscape: 2688 x 1242 pixels

**iPhone 5.5" Display (iPhone 8 Plus, 7 Plus, 6s Plus):**
- Portrait: 1242 x 2208 pixels
- Landscape: 2208 x 1242 pixels

**iPad Pro 12.9" (if supporting iPad):**
- Portrait: 2048 x 2732 pixels
- Landscape: 2732 x 2048 pixels

**Minimum**: 1 screenshot per device family
**Maximum**: 10 screenshots per device family

### 3.3 App Preview Video (Optional)
- **Format**: MP4 or MOV
- **Duration**: 15-30 seconds
- **Resolution**: Match screenshot sizes

## Step 4: Build the Release Archive

### 4.1 Clean and Build
```bash
# Navigate to project root
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build iOS release
flutter build ios --release
```

### 4.2 Create Archive in Xcode

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select "Any iOS Device" or "Generic iOS Device"** as the build target
   - Don't select a simulator

3. **Create Archive:**
   - Menu: **Product → Archive**
   - Wait for the build to complete (may take several minutes)
   - The Organizer window will open automatically

4. **Verify the Archive:**
   - Check that the archive appears in the Organizer
   - Version and build number should match `pubspec.yaml`

## Step 5: Upload to App Store Connect

### 5.1 Distribute the Archive

1. **In Xcode Organizer:**
   - Select your archive
   - Click **"Distribute App"**

2. **Choose Distribution Method:**
   - Select **"App Store Connect"**
   - Click **Next**

3. **Choose Distribution Options:**
   - Select **"Upload"**
   - Click **Next**

4. **Select Distribution Certificate:**
   - Choose **"Automatically manage signing"** (recommended)
   - Or select your distribution certificate
   - Click **Next**

5. **Review and Upload:**
   - Review the summary
   - Click **"Upload"**
   - Wait for upload to complete (may take 10-30 minutes)

### 5.2 Alternative: Using Transporter App

If Xcode upload fails, use Transporter:

1. **Export IPA:**
   - In Xcode Organizer, select archive
   - Click **"Distribute App"**
   - Choose **"Export"** instead of "Upload"
   - Save the `.ipa` file

2. **Upload with Transporter:**
   - Download [Transporter](https://apps.apple.com/app/transporter/id1450874784) from Mac App Store
   - Open Transporter
   - Drag and drop the `.ipa` file
   - Click **"Deliver"**

## Step 6: App Store Connect Setup

### 6.1 Create App Listing

1. **Go to App Store Connect:**
   - Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Sign in with your Apple Developer account

2. **Create New App:**
   - Click **"My Apps"** → **"+"** → **"New App"**
   - Select **iOS** platform
   - Fill in:
     - **Name**: "Congé calculateur"
     - **Primary Language**: French (or your preference)
     - **Bundle ID**: `com.akhele.congecalculateur`
     - **SKU**: Unique identifier (e.g., `congecalculateur-001`)
   - Click **"Create"**

### 6.2 App Information

**1. App Privacy:**
   - Click **"App Privacy"** tab
   - Answer questions about data collection
   - For this app: **No data collection, no tracking**
   - Save

**2. Pricing and Availability:**
   - Set price: **Free**
   - Select countries/regions (or worldwide)
   - Save

### 6.3 Version Information

**1. App Store Listing:**

- **Name**: "Congé calculateur" (30 characters max)
- **Subtitle**: "Calculateur de congés annuels" (30 characters max)
- **Promotional Text** (170 characters max, optional):
  ```
  Calculez vos congés en un clic ! Gestion automatique des week-ends et jours fériés marocains. Gratuit, sans pub, sans collecte de données.
  ```
  *Note: Promotional Text can be updated anytime without submitting a new version. Use it to highlight special features or promotions.*
- **Description** (4000 characters max):
  ```
  Application développée pour aider les agents des douanes marocaines à calculer leurs congés annuels et leur planning de travail.
  
  Fonctionnalités:
  - Calcul automatique des congés annuels
  - Planification du travail (jour/nuit/repos)
  - Support multilingue (Français, Arabe, Anglais)
  - Calcul des jours fériés marocains
  
  Cette application est entièrement gratuite - aucune publicité, aucune collecte de données.
  ```

- **Keywords**: "congés, vacances, calcul, planning, travail, douanes, maroc" (100 characters max, comma-separated)
- **Support URL**: Your website or GitHub repo
- **Marketing URL** (optional): Your website
- **Privacy Policy URL**: **REQUIRED** - Must be a publicly accessible URL

**2. What's New in This Version:**
   ```
   Version initiale de l'application.
   - Calcul des congés annuels
   - Planification du travail
   - Support multilingue
   ```

**3. App Icon:**
   - Upload 1024x1024 PNG icon

**4. Screenshots:**
   - Upload screenshots for at least one device family
   - Add captions if needed

**5. App Preview** (optional):
   - Upload video preview

### 6.4 Build Selection

1. **Wait for Processing:**
   - After upload, wait 10-60 minutes for Apple to process your build
   - Check status in **"TestFlight"** tab or **"App Store"** tab → **"iOS App"** → **"Build"**

2. **Select Build:**
   - Once processed, go to **"App Store"** tab → **"iOS App"**
   - Click **"+"** next to **"Build"**
   - Select your processed build

### 6.5 Version Release

**Release Options:**
- **Automatic**: Release immediately after approval
- **Manual**: Release manually after approval
- **Scheduled**: Release on a specific date

**Recommendation**: Choose **"Manual"** for first release to control timing.

## Step 7: Submit for Review

### 7.1 Complete Required Information

Before submitting, ensure:
- ✅ All required screenshots uploaded
- ✅ App icon uploaded
- ✅ Privacy Policy URL added
- ✅ App Privacy information completed
- ✅ Build selected
- ✅ Version information filled
- ✅ Contact information correct
- ✅ Review notes (if needed)

### 7.2 Export Compliance

**Question**: "Does your app use encryption?"
- **Answer**: **Yes** (Flutter apps use standard encryption)
- **Explanation**: "This app uses standard encryption for HTTPS connections to fetch public holiday data."

### 7.3 Advertising Identifier (IDFA)

**Question**: "Does this app use the Advertising Identifier (IDFA)?"
- **Answer**: **No** (unless you use ads)

### 7.4 Content Rights

**Question**: "Do you have the rights to use all content in your app?"
- **Answer**: **Yes**

### 7.5 Submit for Review

1. Click **"Add for Review"** or **"Submit for Review"**
2. Review the summary
3. Click **"Submit"**
4. Wait for review (typically 24-48 hours, can be up to 7 days)

## Step 8: Review Process

### 8.1 Review Status

Check status in App Store Connect:
- **Waiting for Review**: In queue
- **In Review**: Being reviewed
- **Pending Developer Release**: Approved, waiting for you to release
- **Ready for Sale**: Live on App Store
- **Rejected**: Review failed (check resolution center)

### 8.2 If Rejected

1. **Check Resolution Center:**
   - Read rejection reasons carefully
   - Address all issues

2. **Fix Issues:**
   - Update app if needed
   - Create new build
   - Upload new version

3. **Resubmit:**
   - Update version number
   - Upload new build
   - Submit again

## Step 9: After Approval

### 9.1 Release the App

If you chose **"Manual"** release:
1. Go to App Store Connect
2. Click **"Release This Version"**
3. App will be live within a few hours

### 9.2 Monitor

- Check App Store Connect for:
  - Downloads
  - Ratings and reviews
  - Crash reports
  - Analytics

## Troubleshooting

### Build Errors

**"No signing certificate found":**
- Ensure you're signed in to Xcode with your Apple Developer account
- Check "Signing & Capabilities" in Xcode

**"Bundle identifier already exists":**
- Your bundle ID must be unique
- Change it in Xcode if needed

**"Invalid bundle":**
- Ensure all required assets are present
- Check Info.plist configuration

### Upload Errors

**"Invalid binary":**
- Check that you built for release, not debug
- Ensure all dependencies are included

**"Upload timeout":**
- Use Transporter app instead of Xcode
- Check internet connection

### Review Rejections

**Common reasons:**
- Missing privacy policy URL
- Incomplete app information
- App crashes during review
- Missing required functionality
- Guideline violations

**Solution:**
- Read rejection details carefully
- Fix all mentioned issues
- Resubmit with updated build

## Quick Checklist

Before submitting:
- [ ] Apple Developer account active
- [ ] Bundle ID configured correctly
- [ ] App version set in pubspec.yaml
- [ ] App icon (1024x1024) ready
- [ ] Screenshots prepared
- [ ] Privacy Policy URL ready
- [ ] App Store Connect app created
- [ ] Build uploaded and processed
- [ ] All required information filled
- [ ] App Privacy information completed
- [ ] Export compliance answered
- [ ] Ready to submit for review

## Additional Resources

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Xcode Documentation](https://developer.apple.com/documentation/xcode)

## Support

For issues or questions:
- Apple Developer Support: [developer.apple.com/support](https://developer.apple.com/support)
- App Store Connect Help: Available in App Store Connect dashboard

