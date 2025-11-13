# 🚀 One-Command Play Store Setup

## Quick Start (Everything Automated!)

Just run this one command:

```bash
bash setup_play_store.sh
```

This script will:
1. ✅ Create release keystore (if needed)
2. ✅ Set up key.properties file
3. ✅ Clean and rebuild app bundle
4. ✅ Verify everything is ready

**That's it!** Your app will be ready to upload.

---

## What the Script Does

### Step 1: Creates Keystore
- Prompts you for passwords
- Creates `~/upload-keystore.jks`
- Valid for 10,000 days

### Step 2: Creates key.properties
- Asks for your passwords
- Creates `android/key.properties`
- Configures signing

### Step 3: Builds Release Bundle
- Cleans previous builds
- Gets dependencies
- Builds signed release bundle
- Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 4: Verification
- Checks bundle exists
- Shows file size
- Provides upload path

---

## After Running the Script

Your app bundle will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

**Upload this file to Google Play Console!**

---

## Manual Steps (If Script Doesn't Work)

### 1. Create Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Create key.properties
```bash
cd android
nano key.properties
```

Add:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/Users/macbook/upload-keystore.jks
```

### 3. Build
```bash
flutter clean
flutter build appbundle --release
```

---

## ⚠️ Important Security Notes

- **Keep keystore safe:** `~/upload-keystore.jks`
- **Remember passwords:** Write them down securely
- **Backup keystore:** Copy to secure location
- **Never share:** Don't commit keystore or passwords to git

---

## Troubleshooting

### Script fails?
- Make sure you're in the project root
- Check Java is installed: `java -version`
- Check Flutter is installed: `flutter --version`

### Build fails?
- Run: `flutter clean && flutter pub get`
- Check `android/key.properties` has correct passwords
- Verify keystore path is correct

### Still issues?
Check the detailed guides:
- `SETUP_SIGNING_NOW.md` - Detailed signing setup
- `PLAY_STORE_PUBLISH.md` - Complete publishing guide

---

## Ready to Upload!

Once the script completes successfully, you'll have:
- ✅ Properly signed app bundle
- ✅ Ready for Play Store upload
- ✅ All configurations correct

**Go to:** https://play.google.com/console
**Upload:** `build/app/outputs/bundle/release/app-release.aab`

Good luck! 🎉

