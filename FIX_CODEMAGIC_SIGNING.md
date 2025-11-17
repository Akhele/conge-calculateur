# Fix Codemagic Code Signing Error

## Problem

You're getting this error:
```
POST https://api.appstoreconnect.apple.com/v1/profiles returned 403: 
This request is forbidden for security reasons - You are not allowed to perform this operation.
```

## Root Cause

Your App Store Connect API key doesn't have **Admin** permissions. It needs Admin access to create provisioning profiles.

## Solution Options

### Option 1: Use Admin API Key (Recommended)

**Step 1: Create a New API Key with Admin Access**

1. **Go to App Store Connect:**
   - Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Sign in with your Apple Developer account
   - Click on your name (top right) → **"Users and Access"**
   - Go to **"Keys"** tab

2. **Create a New Key:**
   - Click **"+"** (Generate API Key)
   - Enter a name: `Codemagic iOS Admin Key`
   - ⚠️ **IMPORTANT**: Select **"Admin"** access level (not "App Manager")
   - Click **"Generate"**

3. **Download the Key:**
   - ⚠️ **CRITICAL**: Download the `.p8` file immediately (you can only download once!)
   - Save it securely

4. **Note the Credentials:**
   - **Key ID**: Shown on the keys page (e.g., `3PA2YVL6LN`)
   - **Issuer ID**: Found at the top of the Keys page (e.g., `22d8f3df-c445-47ea-8e6d-5d4ddcf21b9a`)

**Step 2: Update Codemagic**

1. **Go to Codemagic Dashboard:**
   - Teams → Integrations → App Store Connect
   - Click **"Add API Key"** (or edit existing)
   - Upload the new `.p8` file
   - Enter Key ID and Issuer ID
   - Name: `iOS App Store Admin Key`
   - Click **"Add"**

2. **Update the Credentials Group:**
   - Go to Teams → Groups → `app_store_credentials`
   - Remove the old API key
   - Add the new Admin API key
   - Save

3. **Retry the Build:**
   - Start a new build
   - It should now be able to create provisioning profiles

### Option 2: Create Provisioning Profile Manually

If you can't use Admin access, create the profile manually:

**Step 1: Create Profile in Apple Developer Portal**

1. **Go to Apple Developer Portal:**
   - Visit [developer.apple.com/account](https://developer.apple.com/account)
   - Sign in with your Apple Developer account

2. **Navigate to Certificates, Identifiers & Profiles:**
   - Click **"Certificates, Identifiers & Profiles"**

3. **Create Provisioning Profile:**
   - Go to **"Profiles"** section
   - Click **"+"** to create a new profile
   - Select **"App Store"** (not Development or Ad Hoc)
   - Click **"Continue"**
   - Select your App ID: `com.akhele.congecalculateur`
   - Click **"Continue"**
   - Select your **Distribution Certificate** (Apple Distribution: Mounim Ben El Moudene)
   - Click **"Continue"**
   - Enter a name: `Conge Calculateur App Store`
   - Click **"Generate"**
   - Download the profile (optional - Codemagic will fetch it)

**Step 2: Configure Codemagic to Use Existing Profile**

1. **In Codemagic Dashboard:**
   - Go to your app → Code signing
   - Set to use **"Automatic"** code signing
   - Codemagic will automatically fetch the profile you created

2. **Or Update codemagic.yaml:**
   - The current configuration should work once the profile exists
   - Codemagic will find and use the existing profile

### Option 3: Use Manual Code Signing in Codemagic UI

1. **Go to Codemagic Dashboard:**
   - Your app → Code signing
   - Change from "Automatic" to **"Manual"**
   - Upload your distribution certificate
   - Upload your provisioning profile
   - Save

2. **Update codemagic.yaml:**
   - Comment out the automatic signing scripts
   - Use manual signing instead

## Why This Happens

- **App Manager** access can manage apps but **cannot create provisioning profiles**
- **Admin** access can create and manage provisioning profiles
- Creating profiles requires higher permissions for security reasons

## Verification

After fixing, check the build logs for:
```
✅ Found Profile for Bundle ID...
✅ Code signing configured successfully
```

Instead of:
```
❌ 403: This request is forbidden
```

## Quick Fix Summary

**Fastest Solution:**
1. Create new API key with **Admin** access (5 minutes)
2. Update in Codemagic (2 minutes)
3. Retry build (should work now)

**Alternative:**
1. Create provisioning profile manually in Apple Developer Portal (5 minutes)
2. Codemagic will automatically use it (no changes needed)

## Need More Help?

- See full guide: `docs/app-store/CODEMAGIC_SETUP.md`
- Codemagic docs: [docs.codemagic.io/code-signing/ios-code-signing/](https://docs.codemagic.io/code-signing/ios-code-signing/)

