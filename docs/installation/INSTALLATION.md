# Installation and Getting Started

## ✅ Prerequisites

Your Flutter environment is ready:
- ✓ Flutter SDK 3.32.8 installed
- ✓ Android Studio configured
- ✓ VS Code with Flutter extensions
- ✓ Chrome for web development

## 🚀 Quick Start

### 1. Verify Installation

Dependencies are already installed. To verify:

```bash
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur
flutter pub get
```

### 2. Run the Application

#### Option A: On Android Emulator
```bash
flutter run
```

#### Option B: On Chrome (Web)
```bash
flutter run -d chrome
```

#### Option C: On Physical Device
1. Connect your phone via USB
2. Enable developer mode on your phone
3. Run:
```bash
flutter devices  # To see available devices
flutter run      # To launch on connected device
```

### 3. Build the Application

#### For Android (APK)
```bash
flutter build apk --release
```
The APK file will be in: `build/app/outputs/flutter-apk/app-release.apk`

#### For Android (App Bundle - Google Play)
```bash
flutter build appbundle --release
```

#### For iOS (requires Mac with Xcode)
```bash
flutter build ios --release
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## 📱 Project Structure

```
conge-calculateur/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/                      # Data models
│   │   ├── holiday.dart
│   │   └── vacation_calculation.dart
│   ├── screens/                     # Application screens
│   │   ├── home_screen.dart
│   │   ├── calculator_screen.dart
│   │   ├── result_screen.dart
│   │   ├── history_screen.dart
│   │   └── holidays_screen.dart
│   └── services/                    # Business logic
│       ├── holiday_service.dart
│       ├── vacation_calculator.dart
│       └── vacation_provider.dart
├── test/                            # Unit tests
├── pubspec.yaml                     # Dependencies
├── README.md                        # Technical documentation
└── docs/                            # Documentation folder
```

## 🔧 Optional Configuration

### Holiday API (Optional)

The application works with built-in data for 2024-2025. For API integration:

1. Get a free API key from [Calendarific](https://calendarific.com/)
2. Open `lib/services/holiday_service.dart`
3. Replace `YOUR_API_KEY_HERE` with your key:

```dart
static const String apiKey = 'your_api_key';
```

### Customization

#### Change Annual Days
Edit `lib/services/vacation_provider.dart`:
```dart
final int _totalAnnualDays = 22; // Change this value
```

#### Modify Colors
Edit `lib/main.dart`:
```dart
seedColor: const Color(0xFF00BFFF), // Deep sky blue
```

## 📦 Main Dependencies

- **flutter**: Development framework
- **provider**: State management
- **http**: API calls
- **intl**: Date formatting
- **shared_preferences**: Local storage
- **table_calendar**: Calendar widget
- **url_launcher**: Email links

## 🐛 Troubleshooting

### Error: "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Error: "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Error: "Android licenses not accepted"
```bash
flutter doctor --android-licenses
```

### App won't launch
1. Check that a device is connected: `flutter devices`
2. Clean cache: `flutter clean`
3. Reinstall dependencies: `flutter pub get`
4. Relaunch: `flutter run`

## 📊 Performance

### Debug vs Release Mode

- **Debug**: For development, slower
  ```bash
  flutter run
  ```

- **Release**: For production, optimized
  ```bash
  flutter run --release
  ```

### APK Size

The release APK is approximately 15-20 MB.

To reduce size:
```bash
flutter build apk --split-per-abi --release
```

## 🔐 Security

### Local Data
- Data is stored locally with `shared_preferences`
- No data is sent to external servers
- Data is lost when uninstalling

### Required Permissions
- **Internet**: To fetch holidays (optional)
- No other permissions required

## 📱 Compatibility

### Android
- Minimum version: Android 5.0 (API 21)
- Target version: Android 14 (API 34)

### iOS
- Minimum version: iOS 12.0
- Tested up to iOS 17

### Web
- Chrome, Firefox, Safari, Edge
- Responsive design

## 🔄 Updates

To update dependencies:
```bash
flutter pub upgrade
```

To update Flutter:
```bash
flutter upgrade
```

## 📞 Technical Support

### Debug Logs
```bash
flutter run --verbose
```

### System Information
```bash
flutter doctor -v
```

### Clean Project
```bash
flutter clean
flutter pub get
```

## 🎯 Next Steps

1. ✅ Complete installation
2. ✅ Tests passed successfully
3. ✅ Code analysis without errors
4. 📱 Ready to launch!

To start the application:
```bash
flutter run
```

---

**Happy coding! 🚀**
