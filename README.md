# Calculateur de Congé - Moroccan Customs Vacation Calculator

A Flutter application designed specifically for Moroccan customs officers to calculate vacation days with automatic weekend and public holiday handling.

## 🇲🇦 Features

- **Smart Vacation Calculation**: Automatically excludes weekends and public holidays from your 22 working days of annual leave
- **Moroccan Public Holidays**: Integrated with Moroccan national and religious holidays
- **Annual Leave Tracking**: Track your used and remaining vacation days throughout the year
- **History Management**: Keep a record of all your past and upcoming vacations
- **Beautiful UI**: Modern, intuitive interface with Material Design 3

## 📱 How It Works

The app follows the Moroccan customs administration rules:
- You have **22 working days** of annual leave per year
- When you request vacation days, **weekends are automatically added** and don't count toward your 22 days
- **Public holidays** during your vacation are also automatically added and don't count
- The app calculates your exact return-to-work date

### Example
If you request 5 working days starting on a Monday:
- The 5 working days count toward your annual leave
- The weekend (Saturday & Sunday) is automatically added → 7 total days
- If there's a public holiday during this period, it's also added → 8 total days
- The app tells you exactly when you return to work

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone or download this repository
2. Navigate to the project directory:
```bash
cd conge-calculateur
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## 🔧 Configuration

### API Integration (Optional)

The app includes fallback data for Moroccan holidays (2024-2025), but you can optionally integrate with the Calendarific API for more comprehensive data:

1. Get a free API key from [Calendarific](https://calendarific.com/)
2. Open `lib/services/holiday_service.dart`
3. Replace `YOUR_API_KEY_HERE` with your actual API key:

```dart
static const String apiKey = 'your_actual_api_key';
```

If you don't configure an API key, the app will use the built-in holiday data.

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── holiday.dart                   # Holiday data model
│   └── vacation_calculation.dart      # Vacation calculation result model
├── screens/
│   ├── home_screen.dart              # Main dashboard
│   ├── calculator_screen.dart        # Vacation calculator
│   ├── result_screen.dart            # Calculation results
│   ├── history_screen.dart           # Vacation history
│   └── holidays_screen.dart          # Public holidays calendar
└── services/
    ├── holiday_service.dart          # Holiday data fetching
    ├── vacation_calculator.dart      # Core calculation logic
    └── vacation_provider.dart        # State management
```

## 🎨 Screens

1. **Home Screen**: Overview of remaining vacation days with quick access to all features
2. **Calculator Screen**: Input vacation start date and number of working days
3. **Result Screen**: Detailed breakdown showing return date, weekends, and holidays
4. **History Screen**: View all past and upcoming vacations
5. **Holidays Screen**: Complete calendar of Moroccan public holidays

## 💾 Data Persistence

The app uses `shared_preferences` to store:
- Used vacation days
- Vacation history
- All data persists across app restarts

## 🇲🇦 Moroccan Public Holidays Included

### Fixed Holidays
- New Year's Day (1 January)
- Independence Manifesto Day (11 January)
- Labour Day (1 May)
- Throne Day (30 July)
- Oued Ed-Dahab Day (14 August)
- Revolution Day (20 August)
- Youth Day (21 August)
- Green March Day (6 November)
- Independence Day (18 November)

### Islamic Holidays (dates vary by lunar calendar)
- Eid al-Fitr (2 days)
- Eid al-Adha (2 days)
- Islamic New Year
- Mawlid (Prophet's Birthday)

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **SharedPreferences**: Local data persistence
- **HTTP**: API communication
- **Intl**: Date formatting and localization

## 📝 Usage Tips

1. **Start of Year**: Use the "Reset Year" button to start fresh for a new calendar year
2. **Planning**: Check the holidays calendar before planning your vacation
3. **History**: Review your history to track how many days you've used
4. **Confirmation**: Always confirm your calculation to save it to history

## 🤝 Contributing

This app is specifically designed for Moroccan customs officers. If you find any issues or have suggestions for improvements, feel free to modify the code.

## 📄 License

This project is open source and available for personal and organizational use.

## 🙏 Acknowledgments

Built with ❤️ for the Moroccan Customs Administration officers to simplify vacation planning.

---

**Note**: The Islamic holiday dates are approximate and may vary by 1-2 days based on moon sighting. Always verify with official announcements from the Moroccan government.
