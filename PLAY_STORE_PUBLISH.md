# Play Store Publishing Guide - Step by Step

## ✅ Pre-Flight Checklist

Before you start, make sure you have:
- [ ] Google Play Console account ($25 one-time registration fee)
- [ ] App name: "Congé calculateur" ✅
- [ ] Application ID: `com.akhele.congecalculateur` ✅
- [ ] Privacy Policy URL (REQUIRED - see step 3)

---

## Step 1: Set Up Android App Signing 🔐

### Option A: Automated Setup (Recommended)

```bash
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur
bash scripts/setup_android_signing.sh
```

Follow the prompts to create your keystore.

### Option B: Manual Setup

1. **Create a keystore file:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

2. **Create `android/key.properties` file:**
```bash
cd android
nano key.properties
```

Add this content (replace with your actual values):
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/macbook/upload-keystore.jks
```

3. **Save the file** (Ctrl+X, then Y, then Enter)

⚠️ **IMPORTANT**: 
- Keep your keystore file safe! If you lose it, you can't update your app.
- Back it up to a secure location.
- The `key.properties` file is already in `.gitignore` (safe).

---

## Step 2: Build Release App Bundle 📦

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build the App Bundle (required for Play Store)
flutter build appbundle --release
```

**Output location:** `build/app/outputs/bundle/release/app-release.aab`

✅ **Verify the build:**
- Check that the file exists
- File size should be reasonable (usually 10-50 MB)

---

## Step 3: Create Privacy Policy 📄

**REQUIRED** - Play Store requires a privacy policy URL.

### Quick Options:

**Option A: GitHub Pages (Free)**
1. Create a file `privacy-policy.md` in your project
2. Push to GitHub
3. Enable GitHub Pages in repository settings
4. Use URL: `https://yourusername.github.io/repo-name/privacy-policy`

**Option B: Use Template**
1. Copy `PRIVACY_POLICY_TEMPLATE.md` 
2. Customize it with your information
3. Host it somewhere (GitHub Pages, your website, etc.)

**Option C: Privacy Policy Generator**
- Visit: https://www.privacypolicygenerator.info/
- Fill in your app details
- Generate and host the HTML

**What to include:**
- What data you collect (if any)
- How you use the data
- Third-party services (Calendarific API)
- User rights
- Contact information

---

## Step 4: Prepare Store Listing Assets 🎨

### Required Assets:

1. **App Icon** (512x512 PNG, no transparency)
   - Square icon
   - No rounded corners (Play Store adds them)
   - High quality

2. **Feature Graphic** (1024x500 PNG)
   - Horizontal banner
   - Shows app name and key features
   - Used on Play Store listing page

3. **Screenshots** (At least 2, up to 8)
   - **Phone screenshots:**
     - Minimum: 320px width
     - Maximum: 3840px width
     - Aspect ratio: 16:9 or 9:16
   - **Tablet screenshots (optional):**
     - Same requirements as phone

### Screenshot Tips:
- Show key features of your app
- Use real device screenshots (not emulator)
- Include text overlays explaining features
- Show different screens (home, calculator, results, etc.)

### Tools for Creating Assets:
- **Screenshots**: Use your phone or Android Studio emulator
- **Feature Graphic**: Canva, Figma, or Photoshop
- **App Icon**: Use an icon generator or design tool

---

## Step 5: Create Google Play Console Account 🏪

1. **Go to:** https://play.google.com/console
2. **Sign in** with your Google account
3. **Pay registration fee:** $25 (one-time, non-refundable)
4. **Complete account setup:**
   - Developer name
   - Contact information
   - Payment information

---

## Step 6: Create Your App in Play Console 📱

1. **Click "Create app"**
2. **Fill in basic information:**
   - **App name:** Congé calculateur
   - **Default language:** French (or your primary language)
   - **App or game:** App
   - **Free or paid:** Free
   - **Declarations:** Check all that apply
   - **Create app**

---

## Step 7: Complete Store Listing 📝

### 7.1 App Details

- **App name:** Congé calculateur (50 characters max)
- **Short description:** (80 characters max)
  - Example: "Calculateur de congés pour les agents des douanes marocaines"
- **Full description:** (4000 characters max)
  - Describe features, benefits, how to use
  - Use bullet points
  - Include keywords for search

### 7.2 Graphics

- Upload **App icon** (512x512)
- Upload **Feature graphic** (1024x500)
- Upload **Screenshots** (at least 2)

### 7.3 Categorization

- **App category:** Productivity or Utilities
- **Tags:** (optional) vacation, calculator, Morocco, customs

### 7.4 Contact Details

- **Email:** Your contact email
- **Phone:** (optional)
- **Website:** (if you have one)

### 7.5 Privacy Policy

- **Privacy Policy URL:** Enter your privacy policy URL (from Step 3)
- **Required** - App will be rejected without it

---

## Step 8: Content Rating 📊

1. **Click "Content rating"** in left menu
2. **Complete questionnaire:**
   - Does your app contain user-generated content? (Probably No)
   - Does your app contain ads? (Probably No)
   - Does your app collect user data? (Check your privacy policy)
   - Complete all questions
3. **Submit for rating**
4. **Wait for rating** (usually instant or few minutes)

---

## Step 9: Set Up Pricing & Distribution 💰

1. **Go to "Pricing & distribution"**
2. **Select:**
   - **Free** (or Paid if you want to charge)
   - **Countries:** Select where to distribute (or "All countries")
3. **Content guidelines:** Accept
4. **US Export laws:** Accept (if applicable)
5. **Save**

---

## Step 10: Upload App Bundle 📤

1. **Go to "Production"** (or "Internal testing" for testing first)
2. **Click "Create new release"**
3. **Upload your App Bundle:**
   - Click "Upload"
   - Select: `build/app/outputs/bundle/release/app-release.aab`
   - Wait for upload to complete
4. **Add release notes:**
   - **What's new in this version:** (e.g., "Initial release")
   - Can be in multiple languages
5. **Review release**
6. **Save**

---

## Step 11: Complete App Content Form 📋

Play Store may require you to complete:
- **Data safety form** (if you collect data)
- **Target audience** (age groups)
- **Ads** (if applicable)

Fill these out based on your app's actual behavior.

---

## Step 12: Review & Submit ✅

1. **Check "App content"** section:
   - All required items should be green/complete
   - Fix any issues shown

2. **Review checklist:**
   - ✅ Store listing complete
   - ✅ Graphics uploaded
   - ✅ Privacy policy added
   - ✅ Content rating complete
   - ✅ App bundle uploaded
   - ✅ Release notes added

3. **Click "Submit for review"**

---

## Step 13: Wait for Review ⏳

- **Review time:** Usually 1-3 days
- **You'll receive email** when:
  - App is approved
  - App needs changes (rejection)
  - App is published

---

## Step 14: After Publication 🎉

Once published:
- ✅ App will be live on Play Store
- ✅ Monitor reviews and ratings
- ✅ Respond to user feedback
- ✅ Track downloads and analytics
- ✅ Plan updates

---

## Quick Command Reference

```bash
# 1. Set up signing
bash scripts/setup_android_signing.sh

# 2. Build release
flutter clean
flutter pub get
flutter build appbundle --release

# 3. Find your app bundle
ls -lh build/app/outputs/bundle/release/app-release.aab

# 4. Test locally (optional)
flutter install --release
```

---

## Troubleshooting

### Build Fails
- Check `key.properties` exists and is correct
- Verify keystore file path is correct
- Run `flutter clean` and try again

### Upload Fails
- Check file size (should be under 150MB)
- Verify it's an `.aab` file, not `.apk`
- Check internet connection

### App Rejected
- Read rejection reason carefully
- Fix issues mentioned
- Resubmit

---

## Important Notes

⚠️ **Before First Release:**
- Application ID cannot be changed after first release
- Make sure everything is correct!

🔒 **Security:**
- Never share your keystore file
- Keep `key.properties` secure
- Back up keystore to safe location

📱 **Testing:**
- Test release build before submitting
- Install on real device: `flutter install --release`
- Test all features work correctly

---

## Next Steps After Publishing

1. **Monitor:** Check Play Console for reviews and crashes
2. **Respond:** Reply to user reviews
3. **Update:** Plan and release updates
4. **Promote:** Share your app on social media, website, etc.

Good luck with your release! 🚀

