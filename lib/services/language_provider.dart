import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _isFirstLaunchKey = 'is_first_launch';
  
  Locale _locale = const Locale('fr', 'FR');
  bool _isFirstLaunch = true;

  Locale get currentLocale => _locale;
  String get currentLanguage => _locale.languageCode;
  bool get isFirstLaunch => _isFirstLaunch;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if it's first launch
      _isFirstLaunch = prefs.getBool(_isFirstLaunchKey) ?? true;
      
      // Load saved language or default to French
      final languageCode = prefs.getString(_languageKey) ?? 'fr';
      _locale = Locale(languageCode);
      
      // Initialize date formatting for the selected locale
      await _initializeDateFormatting();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> _initializeDateFormatting() async {
    try {
      switch (_locale.languageCode) {
        case 'ar':
          await initializeDateFormatting('ar', null);
          break;
        case 'fr':
          await initializeDateFormatting('fr_FR', null);
          break;
        case 'en':
        default:
          await initializeDateFormatting('en_US', null);
          break;
      }
    } catch (e) {
      debugPrint('Error initializing date formatting: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      // Mark that first launch is complete
      if (_isFirstLaunch) {
        await prefs.setBool(_isFirstLaunchKey, false);
        _isFirstLaunch = false;
      }
      
      // Initialize date formatting for new locale
      await _initializeDateFormatting();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  Future<void> markFirstLaunchComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isFirstLaunchKey, false);
      _isFirstLaunch = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking first launch complete: $e');
    }
  }
}

