# Codemagic iOS Build Setup Guide

This guide will help you configure Codemagic to build and upload your iOS app to the App Store.

## Prerequisites

- [ ] Codemagic account (sign up at [codemagic.io](https://codemagic.io))
- [ ] Apple Developer Account ($99/year)
- [ ] App Store Connect API Key (.p8 file)

## Step 1: Create App Store Connect API Key

The error "Failed to fetch iOS signing files using App Store Connect API" means you need to set up App Store Connect API authentication.

### 1.1 Generate API Key in App Store Connect

1. **Go to App Store Connect:**
   - Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Sign in with your Apple Developer account

2. **Navigate to Users and Access:**
   - Click on your name (top right)
   - Select **"Users and Access"**
   - Go to **"Keys"** tab

3. **Create a New Key:**
   - Click **"+"** (Generate API Key)
   - Enter a name: `Codemagic iOS Key` (or any name you prefer)
   - Select **"App Manager"** or **"Admin"** access level
   - Click **"Generate"**

4. **Download the Key:**
   - ⚠️ **IMPORTANT**: Download the `.p8` file immediately
   - You can only download it once!
   - Save it securely (e.g., `AuthKey_XXXXXXXXXX.p8`)

5. **Note the Credentials:**
   - **Key ID**: Shown on the keys page (e.g., `ABC123DEF4`)
   - **Issuer ID**: Found at the top of the Keys page (e.g., `12345678-1234-1234-1234-123456789012`)
   - **Key File**: The `.p8` file you downloaded

## Step 2: Configure Codemagic

### 2.1 Add App Store Connect API Key to Codemagic

1. **Go to Codemagic Dashboard:**
   - Visit [codemagic.io](https://codemagic.io)
   - Sign in to your account

2. **Navigate to Settings:**
   - Click on your profile icon (top right)
   - Select **"Teams"** → Select your team
   - Go to **"Integrations"** tab

3. **Add App Store Connect API Key:**
   - Find **"App Store Connect"** section
   - Click **"Add API Key"** or **"Manage API Keys"**
   - Click **"Add API Key"** button

4. **Upload the Key:**
   - **Key ID**: Paste your Key ID (e.g., `ABC123DEF4`)
   - **Issuer ID**: Paste your Issuer ID (e.g., `12345678-1234-1234-1234-123456789012`)
   - **Key File**: Upload the `.p8` file you downloaded
   - **Name**: Give it a name (e.g., `iOS App Store Key`)
   - Click **"Add"**

### 2.2 Create App Store Credentials Group

1. **Go to Teams Settings:**
   - In Codemagic, go to **Teams** → Your team → **"Groups"** tab

2. **Create a New Group:**
   - Click **"Add group"**
   - Name: `app_store_credentials`
   - Click **"Create"**

3. **Add API Key to Group:**
   - Click on the `app_store_credentials` group
   - Under **"App Store Connect API keys"**, click **"Add"**
   - Select the API key you just created
   - Click **"Add"**

### 2.3 Configure Your App in Codemagic

1. **Add Your App:**
   - In Codemagic dashboard, click **"Add application"**
   - Connect your Git repository (GitHub, GitLab, Bitbucket, etc.)
   - Select the repository: `conge-calculateur`
   - Codemagic will detect the `codemagic.yaml` file

2. **Verify Configuration:**
   - The `codemagic.yaml` file should reference the group:
     ```yaml
     groups:
       - app_store_credentials
     ```

## Step 3: Configure Code Signing

Codemagic will automatically handle code signing using the App Store Connect API key. The `codemagic.yaml` file includes:

```yaml
- name: Set up code signing settings on Xcode project
  script: |
    xcode-project use-profiles
```

This command automatically:
- Fetches signing certificates from App Store Connect
- Creates provisioning profiles
- Configures your Xcode project

## Step 4: Build and Upload

### 4.1 Start a Build

1. **In Codemagic Dashboard:**
   - Go to your app
   - Select **"iOS Workflow"**
   - Click **"Start new build"**

2. **Select Branch:**
   - Choose the branch to build (usually `main` or `master`)

3. **Start Build:**
   - Click **"Start build"**
   - Wait for the build to complete (usually 10-20 minutes)

### 4.2 Upload to App Store

The build will automatically upload to App Store Connect if configured. To enable automatic upload:

1. **Edit `codemagic.yaml`:**
   - Uncomment or modify the `app_store_connect` section:
     ```yaml
     app_store_connect:
       auth: api_key
       submit_to_testflight: false  # Set to true for TestFlight
       # submit_to_app_store: true  # Uncomment to submit to App Store
     ```

2. **Or Upload Manually:**
   - After build completes, download the `.ipa` file
   - Upload it manually using Xcode Organizer or Transporter

## Troubleshooting

### Error: "Failed to fetch iOS signing files using App Store Connect API"

**Causes:**
- Missing or incorrect App Store Connect API key
- API key not added to the correct group
- Group not referenced in `codemagic.yaml`

**Solutions:**
1. ✅ Verify API key is added in Codemagic Settings → Integrations → App Store Connect
2. ✅ Verify the key is added to the `app_store_credentials` group
3. ✅ Verify `codemagic.yaml` includes:
   ```yaml
   groups:
     - app_store_credentials
   ```
4. ✅ Check that the API key has correct permissions (App Manager or Admin)
5. ✅ Verify Key ID and Issuer ID are correct

### Error: "Cannot create profile: the request does not include any iOS testing devices"

**Cause:**
- Codemagic is trying to create an iOS Development profile, which requires registered devices
- For App Store distribution, you need App Store Distribution profiles (not Development profiles)

**Solution:**
- ✅ The `codemagic.yaml` has been configured to skip the `xcode-project use-profiles` step
- ✅ When using `flutter build ipa`, Codemagic automatically uses App Store Distribution profiles
- ✅ No devices are needed for App Store Distribution profiles
- ✅ The build will automatically create/fetch the correct App Store Distribution profile

**Note:** If you still see this error, ensure:
1. You're building with `flutter build ipa` (not `flutter build ios`)
2. The `codemagic.yaml` doesn't include `xcode-project use-profiles` without the `--type` flag
3. Your App Store Connect API key has permissions to create distribution profiles

### Error: "No signing certificate found"

**Solution:**
- Ensure your Bundle ID (`com.akhele.congecalculateur`) is registered in App Store Connect
- The API key will automatically create certificates if needed

### Error: "Invalid bundle identifier"

**Solution:**
- Verify Bundle ID matches exactly: `com.akhele.congecalculateur`
- Check that the app is created in App Store Connect with this Bundle ID

### Build Fails with CocoaPods Error

**Solution:**
- The `codemagic.yaml` includes CocoaPods installation
- If issues persist, try updating Podfile:
  ```bash
  cd ios && pod repo update && pod install
  ```

## Quick Checklist

Before building:
- [ ] App Store Connect API key created and downloaded (.p8 file)
- [ ] API key added to Codemagic (Settings → Integrations → App Store Connect)
- [ ] `app_store_credentials` group created in Codemagic
- [ ] API key added to the group
- [ ] `codemagic.yaml` file exists in repository root
- [ ] `codemagic.yaml` references `app_store_credentials` group
- [ ] App created in App Store Connect with Bundle ID: `com.akhele.congecalculateur`
- [ ] Git repository connected to Codemagic

## File Location

The `codemagic.yaml` file should be in the **root** of your repository:
```
/Users/macbook/Desktop/flutterProjects/conge-calculateur/codemagic.yaml
```

## Additional Resources

- [Codemagic iOS Code Signing](https://docs.codemagic.io/code-signing/ios-code-signing/)
- [App Store Connect API Keys](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api)
- [Codemagic Documentation](https://docs.codemagic.io/)

## Support

If you encounter issues:
1. Check Codemagic build logs for detailed error messages
2. Verify all steps in this guide are completed
3. Check Codemagic documentation for latest updates
4. Contact Codemagic support if needed

