# API Keys Setup

## Important: Keeping Your API Keys Secure

This project uses a separate configuration file to store API keys, keeping them out of version control.

## Setup Instructions

### For Developers with an API Key:

1. Your API key is already configured in `lib/config/api_keys.dart`
2. This file is automatically ignored by Git (listed in `.gitignore`)
3. **Never commit this file to GitHub**

### For New Team Members or Contributors:

1. Copy the example file:
   ```bash
   cp lib/config/api_keys.dart.example lib/config/api_keys.dart
   ```

2. Open `lib/config/api_keys.dart` and add your API key:
   ```dart
   class ApiKeys {
     static const String calendarificApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   }
   ```

3. Get a free API key from [Calendarific](https://calendarific.com/)

### Using Without an API Key:

If you don't have an API key, the app will work fine with built-in fallback data for Moroccan holidays (2024-2025).

Just leave the key as:
```dart
static const String calendarificApiKey = 'YOUR_API_KEY_HERE';
```

## Files Structure

- `lib/config/api_keys.dart` - **GITIGNORED** - Your actual API keys (never committed)
- `lib/config/api_keys.dart.example` - **COMMITTED** - Template file for other developers
- `.gitignore` - Contains `lib/config/api_keys.dart` to prevent accidental commits

## Security Best Practices

✅ **DO:**
- Keep `api_keys.dart` out of version control
- Use environment variables for production
- Rotate API keys if accidentally exposed

❌ **DON'T:**
- Commit `api_keys.dart` to Git
- Share API keys in chat/email
- Hardcode keys in other files

## If You Accidentally Committed Your API Key

1. Immediately revoke/regenerate the API key at [Calendarific](https://calendarific.com/)
2. Remove it from Git history:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch lib/config/api_keys.dart" \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. Force push (⚠️ use with caution):
   ```bash
   git push origin --force --all
   ```
4. Update your local `api_keys.dart` with the new key

## Questions?

Contact the project maintainer or check the main [README.md](README.md) for more information.

