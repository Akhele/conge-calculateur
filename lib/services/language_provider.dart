import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _isFirstLaunchKey = 'is_first_launch';
  
  Locale _locale = const Locale('fr', 'FR');
  bool _isFirstLaunch = true;
  bool _isLoading = false; // No longer needed since we load in main()

  Locale get currentLocale => _locale;
  String get currentLanguage => _locale.languageCode;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoading => _isLoading;

  LanguageProvider({
    String? initialLanguage,
    bool isFirstLaunch = true,
  }) {
    // Set initial values from constructor
    if (initialLanguage != null && initialLanguage.isNotEmpty) {
      _locale = Locale(initialLanguage);
      _isFirstLaunch = false;
    } else {
      _locale = const Locale('fr', 'FR');
      _isFirstLaunch = isFirstLaunch;
    }
    
    // Still load to ensure date formatting is initialized
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      // Initialize date formatting for the selected locale
      await _initializeDateFormatting();
      
      // Double-check preferences to ensure consistency
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      final isFirstLaunchPref = prefs.getBool(_isFirstLaunchKey);
      
      // Update state if preferences differ (shouldn't happen, but safety check)
      if (languageCode != null && languageCode.isNotEmpty) {
        if (_locale.languageCode != languageCode) {
          _locale = Locale(languageCode);
        }
        if (_isFirstLaunch) {
          _isFirstLaunch = false;
          await prefs.setBool(_isFirstLaunchKey, false);
        }
      } else if (isFirstLaunchPref != null && !isFirstLaunchPref && _isFirstLaunch) {
        _isFirstLaunch = false;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
      notifyListeners();
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
    debugPrint('=== setLanguage called with: $languageCode ===');
    debugPrint('Current locale: ${_locale.languageCode}, isFirstLaunch: $_isFirstLaunch');
    
    // Always save if it's first launch, even if language matches (to mark first launch as complete)
    final shouldSave = _isFirstLaunch || _locale.languageCode != languageCode;
    
    if (!shouldSave) {
      debugPrint('Language already set to $languageCode and not first launch, skipping save');
      return;
    }

    _locale = Locale(languageCode);
    _isFirstLaunch = false;
    
    try {
      debugPrint('Getting SharedPreferences instance...');
      final prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences instance obtained');
      
      // Save language preference with explicit error handling
      debugPrint('Attempting to save language: $languageCode');
      final languageSaved = await prefs.setString(_languageKey, languageCode);
      debugPrint('Language save result: $languageSaved');
      
      if (!languageSaved) {
        debugPrint('ERROR: Failed to save language preference!');
      }
      
      // Always mark that first launch is complete when language is set
      debugPrint('Attempting to save first launch flag: false');
      final flagSaved = await prefs.setBool(_isFirstLaunchKey, false);
      debugPrint('First launch flag save result: $flagSaved');
      
      if (!flagSaved) {
        debugPrint('ERROR: Failed to save first launch flag!');
      }
      
      // Wait a bit to ensure iOS has time to write to disk
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Force a reload to ensure persistence (iOS sometimes needs this)
      debugPrint('Reloading preferences...');
      await prefs.reload();
      debugPrint('Reload completed');
      
      // Verify the save was successful after reload
      final verifyLanguage = prefs.getString(_languageKey);
      final verifyFlag = prefs.getBool(_isFirstLaunchKey);
      debugPrint('=== VERIFICATION ===');
      debugPrint('Expected language: $languageCode, Got: $verifyLanguage');
      debugPrint('Expected first launch: false, Got: $verifyFlag');
      
      if (verifyLanguage != languageCode || verifyFlag != false) {
        debugPrint('WARNING: Preferences not persisted correctly! Retrying save...');
        // Retry save with a fresh instance
        final retryPrefs = await SharedPreferences.getInstance();
        await retryPrefs.setString(_languageKey, languageCode);
        await retryPrefs.setBool(_isFirstLaunchKey, false);
        await Future.delayed(const Duration(milliseconds: 200));
        await retryPrefs.reload();
        debugPrint('Retry verification - Language: ${retryPrefs.getString(_languageKey)}, First launch: ${retryPrefs.getBool(_isFirstLaunchKey)}');
      } else {
        debugPrint('SUCCESS: Preferences verified correctly!');
      }
      
      // Initialize date formatting for new locale
      await _initializeDateFormatting();
      
      notifyListeners();
      debugPrint('=== setLanguage completed ===');
    } catch (e, stackTrace) {
      debugPrint('ERROR in setLanguage: $e');
      debugPrint('Stack trace: $stackTrace');
      // Try to save again on error
      try {
        debugPrint('Attempting retry save...');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);
        await prefs.setBool(_isFirstLaunchKey, false);
        await prefs.reload();
        debugPrint('Retry save completed');
        _isFirstLaunch = false;
        notifyListeners();
      } catch (e2) {
        debugPrint('Retry save also failed: $e2');
      }
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

