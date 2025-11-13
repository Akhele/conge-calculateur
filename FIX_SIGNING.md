# Fix Release Signing - Quick Guide

Your app bundle was signed in debug mode. We need to sign it with a release keystore.

## Option 1: Automated Setup (Easiest)

Run this command and follow the prompts:

```bash
bash scripts/setup_android_signing.sh
```

Then rebuild:
```bash
flutter build appbundle --release
```

## Option 2: Manual Setup

### Step 1: Create Keystore

Run this command (you'll be prompted for passwords):

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**When prompted:**
- Enter a password (remember it!)
- Enter your name/organization info
- Press Enter for defaults
- Type "yes" to confirm

### Step 2: Create key.properties File

```bash
cd android
nano key.properties
```

Add this content (replace with YOUR passwords):

```properties
storePassword=YOUR_STORE_PASSWORD_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
keyAlias=upload
storeFile=/Users/macbook/upload-keystore.jks
```

**Save:** Press Ctrl+X, then Y, then Enter

### Step 3: Rebuild App Bundle

```bash
cd ..
flutter clean
flutter build appbundle --release
```

### Step 4: Upload New Bundle

Upload the new file: `build/app/outputs/bundle/release/app-release.aab`

---

## ⚠️ Important Notes

- **Keep your keystore safe!** If you lose it, you can't update your app.
- **Backup the keystore** to a secure location
- **Remember your passwords** - write them down securely
- The `key.properties` file is already in `.gitignore` (safe)

---

## Verify Signing

After building, you can verify it's signed correctly:

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

If you see "jar verified", it's correctly signed!

