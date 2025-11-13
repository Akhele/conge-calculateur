import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/language_selection_screen.dart';
import 'services/vacation_provider.dart';
import 'services/language_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load language preference before starting the app
  final prefs = await SharedPreferences.getInstance();
  
  // Reload to ensure we have the latest preferences from disk (important for iOS)
  await prefs.reload();
  
  // Debug: Print all keys to see what's actually stored
  debugPrint('=== All SharedPreferences keys ===');
  final allKeys = prefs.getKeys();
  for (final key in allKeys) {
    final value = prefs.get(key);
    debugPrint('Key: $key, Value: $value');
  }
  debugPrint('Total keys: ${allKeys.length}');
  debugPrint('================================');
  
  final languageCode = prefs.getString('selected_language');
  final isFirstLaunchPref = prefs.getBool('is_first_launch');
  
  // Debug logging
  debugPrint('Language preference loaded: $languageCode');
  debugPrint('First launch flag: $isFirstLaunchPref');
  
  // If language is set, it's not first launch
  final isActuallyFirstLaunch = (languageCode == null || languageCode.isEmpty) && (isFirstLaunchPref ?? true);
  
  // Ensure consistency: if language exists, mark as not first launch
  if (languageCode != null && languageCode.isNotEmpty) {
    if (isFirstLaunchPref == null || isFirstLaunchPref == true) {
      await prefs.setBool('is_first_launch', false);
      await prefs.reload(); // Reload after saving
      debugPrint('Updated first launch flag to false');
    }
  }
  
  debugPrint('Is first launch: $isActuallyFirstLaunch');
  
  runApp(MyApp(
    initialLanguage: languageCode,
    isFirstLaunch: isActuallyFirstLaunch,
  ));
}

class MyApp extends StatelessWidget {
  final String? initialLanguage;
  final bool isFirstLaunch;
  
  const MyApp({
    super.key,
    this.initialLanguage,
    this.isFirstLaunch = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(
            initialLanguage: initialLanguage,
            isFirstLaunch: isFirstLaunch,
          ),
        ),
        ChangeNotifierProvider(create: (_) => VacationProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Calculateur de Congé',
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            supportedLocales: const [
              Locale('ar'),
              Locale('fr', 'FR'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00BFFF), // Deep sky blue
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            home: languageProvider.isFirstLaunch
                ? const LanguageSelectionScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}

