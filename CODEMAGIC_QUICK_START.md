# Codemagic Quick Start Guide

## ✅ Your Configuration is Ready!

Your `codemagic.yaml` is already configured correctly. Here's what to do next:

## Step 1: Sign Up / Sign In to Codemagic

1. Go to [codemagic.io](https://codemagic.io)
2. Sign up or sign in with your GitHub account
3. Connect your repository: `conge-calculateur`

## Step 2: Quick Test Build (Without App Store Upload)

For your first test, you can build without App Store Connect setup:

### Option A: Test Build Only (Recommended for First Test)

1. **In Codemagic Dashboard:**
   - Go to your app: `conge-calculateur`
   - Click **"Start new build"**
   - Select **"iOS Workflow"**
   - Select branch: `main`
   - Click **"Start build"**

2. **The build will:**
   - ✅ Install Flutter dependencies
   - ✅ Install CocoaPods
   - ✅ Build the IPA file
   - ❌ Won't upload to App Store (that's fine for testing)

3. **Check the build:**
   - Wait 10-20 minutes
   - Download the IPA file from artifacts
   - Verify it builds successfully

### Option B: Full Setup with App Store Upload

If you want to test the full pipeline:

## Step 3: Set Up App Store Connect API Key

1. **Create API Key in App Store Connect:**
   - Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Users and Access → Keys → "+"
   - Name: `Codemagic iOS Key`
   - Access: **App Manager** or **Admin**
   - Click **Generate**
   - ⚠️ **Download the .p8 file immediately** (you can only download once!)
   - Note the **Key ID** and **Issuer ID**

2. **Add to Codemagic:**
   - Codemagic Dashboard → Teams → Integrations → App Store Connect
   - Click **"Add API Key"**
   - Upload the .p8 file
   - Enter Key ID and Issuer ID
   - Name: `iOS App Store Key`
   - Click **"Add"**

3. **Create Credentials Group:**
   - Codemagic → Teams → Groups
   - Click **"Add group"**
   - Name: `app_store_credentials`
   - Click **"Create"**
   - Click on the group
   - Under "App Store Connect API keys", click **"Add"**
   - Select your API key
   - Click **"Add"**

## Step 4: Start Your First Build

1. **In Codemagic Dashboard:**
   - Go to your app
   - Click **"Start new build"**
   - Select **"iOS Workflow"**
   - Select branch: `main`
   - Click **"Start build"**

2. **Monitor the Build:**
   - Watch the build logs in real-time
   - The build should take 10-20 minutes
   - Check for any errors

## Step 5: Verify Build Success

**Look for these in the build logs:**
- ✅ `flutter pub get` - Success
- ✅ `pod install` - Success
- ✅ `flutter build ipa` - Success
- ✅ IPA file created in artifacts

**If you see errors:**
- Check the error messages
- Common issues:
  - Code signing errors → Need to configure code signing in Codemagic UI
  - API key errors → Verify API key is added to the group
  - Build errors → Check Flutter/CocoaPods dependencies

## Step 6: Download IPA (For Testing)

1. **After build completes:**
   - Go to the build page
   - Scroll to **"Artifacts"** section
   - Download the `.ipa` file
   - You can install this on a device for testing (if signed)

## Step 7: Enable App Store Upload (When Ready)

Once your build works, enable App Store upload:

1. **Edit `codemagic.yaml`:**
   - Uncomment line 80: `# submit_to_app_store: true`
   - Or set `submit_to_testflight: true` for TestFlight testing

2. **Create App in App Store Connect:**
   - See: `APP_STORE_READINESS_CHECKLIST.md` Step 3

3. **Run build again:**
   - The build will automatically upload to App Store Connect

## Troubleshooting

### Build Fails with Code Signing Error

**Solution:**
1. Go to Codemagic → Your app → Code signing
2. Set distribution type to **"App Store"**
3. Enable automatic code signing
4. Save and rebuild

### Build Fails with "Failed to fetch iOS signing files"

**Solution:**
1. Verify API key is added to Codemagic
2. Verify API key is added to `app_store_credentials` group
3. Verify `codemagic.yaml` references the group (already done ✓)

### Build Succeeds but IPA Not Created

**Solution:**
- Check artifacts section
- Verify build actually completed (not just started)
- Check for errors in build logs

## What's Different from Xcode Cloud?

✅ **Codemagic Advantages:**
- Native Flutter support (Flutter pre-installed)
- Better error messages
- Easier configuration
- Automatic dependency management
- Better build logs

❌ **Xcode Cloud Issues (Why we switched):**
- Flutter not pre-installed
- Scripts may not run correctly
- More complex setup
- Less Flutter-friendly

## Next Steps After Successful Build

1. ✅ Verify build works
2. ✅ Set up App Store Connect API key
3. ✅ Create app in App Store Connect
4. ✅ Enable App Store upload in codemagic.yaml
5. ✅ Submit for review

## Quick Reference

- **Codemagic Dashboard:** [codemagic.io](https://codemagic.io)
- **App Store Connect:** [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- **Full Setup Guide:** `docs/app-store/CODEMAGIC_SETUP.md`
- **Readiness Checklist:** `APP_STORE_READINESS_CHECKLIST.md`

## Need Help?

- Check build logs for specific errors
- See `docs/app-store/CODEMAGIC_SETUP.md` for detailed setup
- Codemagic documentation: [docs.codemagic.io](https://docs.codemagic.io)

