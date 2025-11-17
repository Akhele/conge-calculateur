# App Store Review Requirements - Complete Checklist

## ✅ Build Uploaded Successfully!

Your Codemagic build worked! Now you need to complete the App Store Connect information before submitting for review.

## Required Information to Complete

### 1. Export Compliance Information ⚠️ REQUIRED

**Location:** App Store Connect → Your App → App Store → iOS App → Version Information

**Steps:**
1. Go to your app in App Store Connect
2. Click on the version you want to submit (e.g., "1.0.0")
3. Scroll down to **"Export Compliance"** section
4. Answer the question: **"Does your app use encryption?"**

**Answer: YES** (Flutter apps use standard encryption for HTTPS)

5. **Next question:** "What type of encryption algorithms does your app implement?"

**Answer: "None of the algorithms mentioned above"**

**Why:** Your app only uses HTTPS/TLS encryption which is provided by Apple's operating system (iOS). You don't implement:
- Proprietary encryption algorithms
- Custom standard encryption algorithms
- The app uses the built-in HTTPS/TLS from iOS/Apple's system

6. **Then provide explanation:**
- **Explanation:** `This app uses standard HTTPS/TLS encryption provided by Apple's iOS operating system for secure API communication. No custom encryption algorithms are implemented.`

**Or use this shorter version:**
- **Explanation:** `Uses only HTTPS/TLS encryption provided by Apple's iOS system. No custom encryption.`

7. Click **"Save"**

---

### 2. App Privacy Information ⚠️ REQUIRED

**Location:** App Store Connect → Your App → App Privacy

**Steps:**
1. Go to your app in App Store Connect
2. Click **"App Privacy"** tab (left sidebar)
3. Click **"Get Started"** or **"Edit"**

**For your app (no data collection):**

**Question: "Does your app collect data?"**
- Answer: **NO**

**If it asks about specific data types:**
- Select **"No, we do not collect data from this app"**
- Click **"Save"**

**If you need to be more specific:**
- Go through each category and select **"No"** or **"We do not collect this data"**
- Common categories to check:
  - Location Data → **No**
  - Contact Info → **No**
  - User Content → **No**
  - Identifiers → **No**
  - Usage Data → **No**
  - Diagnostics → **No**
  - Other Data → **No**

**Note:** Since your app only fetches public holiday data (no user data), you should select "No" for all categories.

---

### 3. Contact Information ⚠️ REQUIRED

**Location:** App Store Connect → Your App → App Information → Contact Information

**Steps:**
1. Go to your app in App Store Connect
2. Click **"App Information"** tab (left sidebar)
3. Scroll to **"Contact Information"** section
4. Fill in:
   - **First Name:** Your first name (e.g., `Mounim`)
   - **Last Name:** Your last name (e.g., `Ben El Moudene`)
   - **Phone Number:** Your phone number (include country code, e.g., `+212XXXXXXXXX`)
   - **Email:** Your email address (e.g., `contact@akhele.com`)
5. Click **"Save"**

---

### 4. Copyright Information ⚠️ REQUIRED

**Location:** App Store Connect → Your App → App Store → iOS App → App Information

**Steps:**
1. Go to your app in App Store Connect
2. Click **"App Store"** tab → **"iOS App"**
3. Scroll to **"App Information"** section
4. Find **"Copyright"** field
5. Enter your copyright information:

**Format options:**
- `© 2024 Mounim Ben El Moudene`
- `© 2024 Akhele`
- `Copyright © 2024 Mounim Ben El Moudene. All rights reserved.`

**Use this format:**
```
© 2024 Mounim Ben El Moudene
```

6. Click **"Save"**

---

### 5. Other Common Requirements

#### App Information (if not completed)

**Location:** App Store Connect → Your App → App Information

**Required fields:**
- **Name:** `Congé calculateur` ✓ (already set)
- **Primary Language:** `French` (or your preference)
- **Bundle ID:** `com.akhele.congecalculateur` ✓ (already set)
- **SKU:** `congecalculateur-001` (or your unique identifier)

#### App Store Listing (if not completed)

**Location:** App Store Connect → Your App → App Store → iOS App

**Required fields:**
- **Name:** `Congé calculateur` (30 chars max)
- **Subtitle:** `Calculateur de congés annuels` (30 chars max)
- **Description:** Use content from `GOOGLE_PLAY_DESCRIPTION_FR.txt`
- **Keywords:** `congés, vacances, calcul, planning, travail, douanes` (100 chars max)
- **Support URL:** Your website or GitHub repo (e.g., `https://github.com/Akhele/conge-calculateur`)
- **Privacy Policy URL:** **REQUIRED** - Must be publicly accessible
  - Can host on GitHub Pages, your website, etc.
  - See: `docs/play-store/PRIVACY_POLICY_TEMPLATE.md` for template

#### Screenshots (if not uploaded)

**Location:** App Store Connect → Your App → App Store → iOS App → Screenshots

**Required:**
- At least 1 set of screenshots for one device family
- Minimum sizes:
  - iPhone 6.7": 1290 x 2796 pixels (portrait)
  - iPhone 6.5": 1242 x 2688 pixels (portrait)
  - iPhone 5.5": 1242 x 2208 pixels (portrait)

#### App Icon (if not uploaded)

**Location:** App Store Connect → Your App → App Store → iOS App → App Icon

**Required:**
- 1024x1024 PNG
- No transparency, no rounded corners

---

## Quick Fix Checklist

Before submitting, ensure all of these are completed:

- [ ] **Export Compliance:** Answered "Yes" with explanation about HTTPS encryption
- [ ] **App Privacy:** Set to "No data collection" or completed all categories
- [ ] **Contact Information:** First name, last name, phone, email filled in
- [ ] **Copyright:** Copyright text entered (e.g., `© 2024 Mounim Ben El Moudene`)
- [ ] **App Store Listing:** Name, subtitle, description, keywords filled
- [ ] **Privacy Policy URL:** Added and publicly accessible
- [ ] **Support URL:** Added
- [ ] **Screenshots:** At least 1 set uploaded
- [ ] **App Icon:** 1024x1024 PNG uploaded
- [ ] **Build Selected:** Your build is selected in the version

---

## Step-by-Step Submission Process

### Step 1: Complete All Required Information

1. **Export Compliance:**
   - App Store Connect → Your App → App Store → iOS App → Version
   - Answer "Yes" to encryption question
   - Add explanation about HTTPS

2. **App Privacy:**
   - App Store Connect → Your App → App Privacy
   - Set to "No data collection"

3. **Contact Information:**
   - App Store Connect → Your App → App Information
   - Fill in contact details

4. **Copyright:**
   - App Store Connect → Your App → App Store → iOS App → App Information
   - Add copyright text

### Step 2: Verify Everything is Complete

1. Go to your app version page
2. Check for any red error indicators
3. All sections should show green checkmarks or be completed

### Step 3: Submit for Review

1. Go to your app version page
2. Click **"Add for Review"** or **"Submit for Review"**
3. Review the summary
4. Click **"Submit"**

---

## Common Issues

### "Export Compliance" Error

**Solution:**
- Go to Version Information → Export Compliance
- Answer "Yes" to encryption question
- Add explanation: `Standard HTTPS encryption for API calls`

### "App Privacy" Error

**Solution:**
- Go to App Privacy tab
- Select "No, we do not collect data from this app"
- Save

### "Contact Information" Error

**Solution:**
- Go to App Information → Contact Information
- Fill in all required fields (name, phone, email)
- Save

### "Copyright" Error

**Solution:**
- Go to App Store → iOS App → App Information
- Find Copyright field
- Enter: `© 2024 [Your Name]`
- Save

### "Privacy Policy URL" Error

**Solution:**
- Create a privacy policy page (can use GitHub Pages)
- Add the URL in App Store listing
- Ensure it's publicly accessible (no login required)

---

## Privacy Policy Template

If you need a privacy policy, you can use the template in:
- `docs/play-store/PRIVACY_POLICY_TEMPLATE.md`

Or create a simple one stating:
- No data collection
- No tracking
- No ads
- No third-party sharing

Host it on:
- GitHub Pages (free)
- Your website
- Any public URL

---

## After Submission

Once you submit:
1. **Status:** Will change to "Waiting for Review"
2. **Review Time:** Typically 24-48 hours (can be up to 7 days)
3. **Notifications:** You'll receive email updates on status changes

**Possible Outcomes:**
- ✅ **Approved:** App goes live (or waits for manual release)
- ⚠️ **Rejected:** Check Resolution Center for details and fix issues
- 📝 **In Review:** Being reviewed by Apple

---

## Need Help?

- **App Store Connect Help:** Available in the dashboard
- **Apple Developer Support:** [developer.apple.com/support](https://developer.apple.com/support)
- **Your Documentation:** `docs/app-store/APP_STORE_SUBMISSION.md`

---

## Quick Reference

**App Store Connect:** [appstoreconnect.apple.com](https://appstoreconnect.apple.com)

**Required Sections:**
1. Export Compliance → Version Information
2. App Privacy → App Privacy tab
3. Contact Information → App Information
4. Copyright → App Store → iOS App → App Information

**All must be completed before you can submit!**

