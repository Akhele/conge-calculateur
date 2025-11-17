# Xcode Cloud Troubleshooting Guide

## Current Issue: Missing Generated.xcconfig and Pods Files

### Symptoms
- `could not find included file 'Generated.xcconfig'`
- `Unable to load contents of file list: Pods-Runner-frameworks-Release-input-files.xcfilelist`
- `Unable to load contents of file list: Pods-Runner-frameworks-Release-output-files.xcfilelist`

### Step 1: Check if Script is Running

**In Xcode Cloud build logs, look for:**
```
🚀 Xcode Cloud Post-Clone Script Starting
```

**If you DON'T see this:**
- The script `ci_post_clone.sh` is not running
- Check that the file exists in the repository root
- Verify it's committed and pushed
- Check file permissions (should be executable: `chmod +x ci_post_clone.sh`)

**If you DO see the script output:**
- Check what errors it reports
- Look for Flutter installation status
- Check CocoaPods installation status

### Step 2: Check Flutter Availability

**In the build logs, look for:**
```
✅ Flutter found: Flutter 3.x.x
```

**If you see:**
```
⚠️ WARNING: Flutter is not available
```

**Solutions:**
1. **Install Flutter in Xcode Cloud** (if possible)
   - Configure Flutter installation in workflow settings
   - Or use a custom build environment

2. **Use Codemagic instead** (Recommended)
   - Codemagic has native Flutter support
   - Better suited for Flutter projects
   - See: `docs/app-store/CODEMAGIC_SETUP.md`

3. **Commit Generated.xcconfig** (Not recommended, but works)
   - See "Alternative Solution" below

### Step 3: Check CocoaPods Installation

**In the build logs, look for:**
```
✅ CocoaPods found: 1.x.x
```

**If CocoaPods is missing:**
- The script will attempt to install it
- If installation fails, check build logs for errors
- CocoaPods should be pre-installed in Xcode Cloud

### Step 4: Verify Files Were Created

**Check the final status in logs:**
```
📋 Final Status Check
✅ Generated.xcconfig: EXISTS
✅ Pods directory: EXISTS
✅ Pods-Runner-frameworks-Release-input-files.xcfilelist: EXISTS
✅ Pods-Runner-frameworks-Release-output-files.xcfilelist: EXISTS
```

**If files are missing:**
- Check the error messages above
- The script will attempt to create fallback files
- But build may still fail if Flutter isn't available

## Alternative Solution: Commit Generated.xcconfig

**⚠️ Warning:** This is not recommended but may be necessary if Flutter isn't available in Xcode Cloud.

### Steps:

1. **Generate Generated.xcconfig locally:**
   ```bash
   cd /Users/macbook/Desktop/flutterProjects/conge-calculateur
   flutter pub get
   ```

2. **Edit the file to use relative paths:**
   ```bash
   # Edit ios/Flutter/Generated.xcconfig
   # Change FLUTTER_ROOT to a relative path or remove it
   # Change FLUTTER_APPLICATION_PATH to use $(SRCROOT)
   ```

3. **Create a template version:**
   ```bash
   # Copy Generated.xcconfig to a template
   cp ios/Flutter/Generated.xcconfig ios/Flutter/Generated.xcconfig.template
   ```

4. **Update .gitignore to allow it:**
   ```bash
   # Remove or comment out the line that ignores Generated.xcconfig
   # In .gitignore, ensure ios/Flutter/Generated.xcconfig is NOT ignored
   ```

5. **Commit it:**
   ```bash
   git add ios/Flutter/Generated.xcconfig
   git commit -m "Add Generated.xcconfig for Xcode Cloud compatibility"
   git push
   ```

**Note:** This file contains local paths and may need to be updated for Xcode Cloud environment.

## Recommended Solution: Use Codemagic

**Why Codemagic is better for Flutter:**
- Native Flutter support
- Pre-installed Flutter SDK
- Better error messages
- Easier configuration
- Free tier available

**Setup:**
1. See: `docs/app-store/CODEMAGIC_SETUP.md`
2. Configure App Store Connect API key
3. Build and upload automatically

## Check Script Execution

**To verify the script runs, add this to the top of `ci_post_clone.sh`:**
```bash
echo "SCRIPT_EXECUTED_AT_$(date +%s)" > /tmp/ci_script_executed.txt
```

**Then check build logs for this file creation.**

## Common Issues

### Issue: Script not running
**Solution:** 
- Ensure file is named exactly `ci_post_clone.sh`
- Ensure it's in the repository root (not in a subdirectory)
- Ensure it's executable: `chmod +x ci_post_clone.sh`
- Ensure it's committed and pushed

### Issue: Flutter not found
**Solution:**
- Use Codemagic (recommended)
- Or commit Generated.xcconfig (not recommended)
- Or configure Flutter installation in Xcode Cloud

### Issue: CocoaPods not installing
**Solution:**
- CocoaPods should be pre-installed
- Check if `gem` is available
- Check build logs for installation errors

### Issue: Files created but build still fails
**Solution:**
- Check file paths in Xcode project
- Verify Release.xcconfig includes are correct
- Check Xcode build settings

## Next Steps

1. **Check build logs** for script output
2. **Verify script is running** (look for script start message)
3. **Check Flutter availability** (look for Flutter version)
4. **Verify files created** (check final status)
5. **If still failing**, consider using Codemagic instead

## Getting Help

If issues persist:
1. Check Xcode Cloud build logs thoroughly
2. Look for script output messages
3. Check for Flutter/CocoaPods errors
4. Consider switching to Codemagic for better Flutter support

