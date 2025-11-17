# Xcode Cloud CI Scripts

This directory contains scripts that run automatically during Xcode Cloud builds.

## Scripts

### `ci_pre_xcodebuild.sh`
Runs before Xcode builds the project. This script:
1. Verifies Flutter is available
2. Runs `flutter pub get` to generate Flutter configuration files
3. Installs CocoaPods dependencies with `pod install`
4. Verifies all required files are present

## Requirements

- Flutter SDK must be available in the build environment
- CocoaPods must be installed (script will attempt to install if missing)

## How It Works

Xcode Cloud automatically detects and runs scripts in the `ci_scripts/` directory:
- Scripts starting with `ci_pre_` run before the build
- Scripts starting with `ci_post_` run after the build

The script name `ci_pre_xcodebuild.sh` ensures it runs before Xcode starts building.

## Troubleshooting

If builds fail with "could not find included file 'Generated.xcconfig'":
1. Check that this script is executable: `chmod +x ci_scripts/ci_pre_xcodebuild.sh`
2. Verify Flutter is available in the build environment
3. Check build logs for script output

