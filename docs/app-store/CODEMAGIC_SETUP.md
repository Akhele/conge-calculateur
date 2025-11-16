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
- Codemagic is automatically trying to create an iOS Development profile before your scripts run
- Development profiles require at least one registered device in Apple Developer Portal
- This happens because Codemagic's automatic code signing setup defaults to development profiles

**Solutions (choose one):**

#### Solution 1: Register a Device (Quickest Fix)
1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles** → **Devices**
3. Click **"+"** to add a new device
4. Enter your device UDID (you can find it in Xcode or Settings → General → About)
5. Register the device
6. Retry the Codemagic build

**Note:** Even though you're building for App Store distribution, registering one device will allow Codemagic to create the development profile it's trying to create, and the build will proceed.

#### Solution 2: Configure Codemagic UI (Recommended)
1. Go to your app in Codemagic dashboard
2. Click on **"Code signing"** in the app settings
3. If there's an option for **"Distribution type"**, set it to **"App Store"** (not "Development")
4. Save and retry the build

#### Solution 3: Use Manual Code Signing
If the above don't work, you can configure manual code signing:
1. Create App Store Distribution certificate and profile manually in Apple Developer Portal
2. Upload them to Codemagic
3. Configure the workflow to use manual signing

**Why this happens:**
Codemagic automatically calls `app-store-connect fetch-signing-files` with `--type IOS_APP_DEVELOPMENT` before your scripts run. This is Codemagic's automatic code signing setup, which defaults to development profiles. The `codemagic.yaml` scripts run after this automatic step, so we can't prevent it from trying to create development profiles.

### Error: "Invalid Provisioning Profile. Missing code-signing certificate. A distribution provisioning profile should be used"

**Cause:**
- The IPA was built with a Development provisioning profile instead of an App Store Distribution profile
- Development profiles cannot be used for App Store uploads
- This happens when Codemagic's automatic code signing uses development profiles before your scripts run

**Root Cause:**
Codemagic automatically calls `app-store-connect fetch-signing-files` with `--type IOS_APP_DEVELOPMENT` before your YAML scripts run. This automatic step uses Development profiles, which cannot be used for App Store uploads.

**Solutions (try in order):**

#### Solution 1: Configure Codemagic UI Code Signing (RECOMMENDED)

This is the most reliable solution:

1. **Go to Codemagic Dashboard:**
   - Navigate to your app
   - Click on **"Code signing"** tab (or find it in app settings)

2. **Configure Code Signing:**
   - Look for **"Distribution type"** or **"Profile type"** setting
   - Change it from **"Development"** to **"App Store"** or **"Distribution"**
   - If there's a **"Automatic code signing"** option, ensure it's enabled
   - Save the settings

3. **Alternative: Disable Automatic Code Signing:**
   - If available, disable automatic code signing in UI
   - Let the `codemagic.yaml` scripts handle it with `--type IOS_APP_STORE`

4. **Rebuild:**
   - Trigger a new build
   - The build should now use App Store Distribution profiles

#### Solution 2: Verify YAML Configuration

1. ✅ Ensure `codemagic.yaml` includes `xcode-project use-profiles --type IOS_APP_STORE`
2. ✅ Verify `ios/ExportOptions.plist` has `method` set to `app-store`
3. ✅ Check that the build uses `flutter build ipa` (not `flutter build ios`)
4. ✅ Check Codemagic build logs - look for which profile type was used

#### Solution 3: Manual Profile Creation

If the above don't work:

1. **Create App Store Distribution Profile Manually:**
   - Go to [Apple Developer Portal](https://developer.apple.com/account)
   - Navigate to **Certificates, Identifiers & Profiles** → **Profiles**
   - Create a new profile with type **"App Store"**
   - Download the profile

2. **Upload to Codemagic:**
   - Go to Codemagic → Your app → Code signing
   - Upload the App Store Distribution profile manually
   - Configure the workflow to use manual signing

**Verification:**
After building, verify the IPA was signed correctly:
```bash
# Check the provisioning profile in the IPA
unzip -q YourApp.ipa -d /tmp/ipa_check
security cms -D -i /tmp/ipa_check/Payload/Runner.app/embedded.mobileprovision | grep -A 5 "ProvisionedDevices"

# If "ProvisionedDevices" appears, it's a Development profile (WRONG)
# For App Store distribution, there should be NO "ProvisionedDevices" key
# The profile type should be "App Store" or "Distribution"
```

**Check Build Logs:**
In Codemagic build logs, look for:
- `fetch-signing-files --type IOS_APP_DEVELOPMENT` ← This is the problem
- `fetch-signing-files --type IOS_APP_STORE` ← This is what we want

If you see `IOS_APP_DEVELOPMENT`, Codemagic UI settings are overriding your YAML configuration.

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

