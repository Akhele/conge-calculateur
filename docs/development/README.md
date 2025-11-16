# Development Tools & Scripts

This folder contains development scripts and automation tools.

## 📚 Available Scripts

### 🚀 Setup Scripts
- **[setup_play_store.sh](setup_play_store.sh)** - Automated Play Store setup (creates keystore, configures signing)

### 📦 Build Scripts
- **[scripts/build_release.sh](scripts/build_release.sh)** - Builds release versions for Android and iOS
- **[scripts/setup_android_signing.sh](scripts/setup_android_signing.sh)** - Sets up Android app signing

## 🎯 Usage

### Play Store Setup
```bash
bash setup_play_store.sh
```
This script will:
- Create Android keystore
- Configure signing properties
- Build release app bundle
- Verify the build

### Build Release
```bash
bash scripts/build_release.sh
```
This script will:
- Clean previous builds
- Get dependencies
- Build Android App Bundle (.aab)
- Build Android APK
- Build iOS (on macOS)

## 📝 Notes

- All scripts include error handling and colored output
- Scripts will prompt for required information (passwords, etc.)
- Make sure you have Flutter installed and in your PATH

