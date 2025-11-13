import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/vacation_calculation.dart';
import '../models/holiday.dart';
import 'holiday_service.dart';
import 'vacation_calculator.dart';

class VacationProvider extends ChangeNotifier {
  final HolidayService _holidayService = HolidayService();
  List<Holiday> _holidays = [];
  VacationCalculation? _currentCalculation;
  bool _isLoading = false;
  String? _error;
  bool _hasInternetConnection = true;
  String? _currentLanguage; // Store current language for API calls
  
  // Annual leave tracking
  int _totalAnnualDays = 22;
  int _usedDays = 0;
  List<VacationCalculation> _history = [];

  List<Holiday> get holidays => _holidays;
  VacationCalculation? get currentCalculation => _currentCalculation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasInternetConnection => _hasInternetConnection;
  int get totalAnnualDays => _totalAnnualDays;
  int get usedDays => _usedDays;
  int get remainingDays => _totalAnnualDays - _usedDays;
  List<VacationCalculation> get history => _history;

  VacationProvider() {
    _loadSavedData();
    _checkConnectivityAndLoadHolidays();
  }

  /// Check internet connectivity by making a simple HTTP request
  Future<bool> _checkInternetConnection() async {
    try {
      // Try to connect to a reliable endpoint (using the API base URL)
      final response = await http
          .get(Uri.parse('https://calendarific.com'))
          .timeout(const Duration(seconds: 3));
      _hasInternetConnection = response.statusCode >= 200 && response.statusCode < 500;
      return _hasInternetConnection;
    } catch (e) {
      // If API endpoint fails, try a simple connectivity check
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 2));
        _hasInternetConnection = response.statusCode == 200;
        return _hasInternetConnection;
      } catch (e2) {
        _hasInternetConnection = false;
        return false;
      }
    }
  }

  /// Check internet connectivity and load holidays
  Future<void> _checkConnectivityAndLoadHolidays() async {
    // First, try to load cached holidays
    await _loadCachedHolidays();
    
    // Check if holidays were already fetched today
    final wereFetchedToday = await _wereHolidaysFetchedTodayAsync();
    
    if (wereFetchedToday && _holidays.isNotEmpty) {
      // Holidays were fetched today and we have cached data - use it
      debugPrint('Using cached holidays from today (${_holidays.length} holidays)');
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    // Holidays not fetched today or cache is empty - fetch from API
    debugPrint('Holidays not fetched today or cache empty - fetching from API');
    
    // Check internet connection
    final hasInternet = await _checkInternetConnection();
    _hasInternetConnection = hasInternet;
    
    // Load holidays from API (will use fallback if API fails or no internet)
    await _loadHolidays();
  }

  /// Set the current language for API calls
  Future<void> setLanguage(String? language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      
      // Check if holidays were already fetched today
      final wereFetchedToday = await _wereHolidaysFetchedTodayAsync();
      
      if (wereFetchedToday && _holidays.isNotEmpty) {
        // Holidays were fetched today - use cached data (language change doesn't require new API call)
        debugPrint('Language changed but holidays already fetched today - using cached data');
        notifyListeners();
        return;
      }
      
      // Holidays not fetched today or cache empty - reload holidays
      await _loadHolidays();
    }
  }

  /// Check if device has internet connection
  Future<bool> checkInternetConnection() async {
    final hasInternet = await _checkInternetConnection();
    _hasInternetConnection = hasInternet;
    notifyListeners();
    return hasInternet;
  }

  /// Load cached holidays from storage
  Future<void> _loadCachedHolidays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final holidaysJson = prefs.getString('cachedHolidays');
      if (holidaysJson != null) {
        final List<dynamic> decoded = json.decode(holidaysJson);
        _holidays = decoded.map((item) => Holiday.fromJson(item)).toList();
        debugPrint('Loaded ${_holidays.length} cached holidays');
      }
    } catch (e) {
      debugPrint('Error loading cached holidays: $e');
    }
  }

  /// Save holidays to cache with today's date
  Future<void> _saveCachedHolidays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final holidaysJson = json.encode(_holidays.map((h) => h.toJson()).toList());
      await prefs.setString('cachedHolidays', holidaysJson);
      
      // Save today's date as the last fetch date
      await prefs.setString('holidaysLastFetchDate', DateTime.now().toIso8601String());
      debugPrint('Saved holidays and marked fetch date as today');
    } catch (e) {
      debugPrint('Error saving cached holidays: $e');
    }
  }
  
  /// Check if holidays were fetched today (async version)
  Future<bool> _wereHolidaysFetchedTodayAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastFetchDateStr = prefs.getString('holidaysLastFetchDate');
      if (lastFetchDateStr == null) {
        debugPrint('No last fetch date found - will fetch from API');
        return false;
      }
      
      final lastFetchDate = DateTime.parse(lastFetchDateStr);
      final today = DateTime.now();
      
      // Check if last fetch was today (same day, month, year)
      final isToday = lastFetchDate.year == today.year &&
                     lastFetchDate.month == today.month &&
                     lastFetchDate.day == today.day;
      
      if (isToday) {
        debugPrint('Holidays were already fetched today (${lastFetchDate.toIso8601String()}) - using cached data');
      } else {
        debugPrint('Last fetch was on ${lastFetchDate.toIso8601String()} - will fetch from API');
      }
      
      return isToday;
    } catch (e) {
      debugPrint('Error checking fetch date: $e');
      return false;
    }
  }

  Future<void> _loadHolidays() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentYear = DateTime.now().year;
      final allHolidays = <Holiday>[];
      
      // Load holidays for current year, next year, and year after next
      // This ensures we have holidays for vacations that span multiple years
      // API will provide both national and Islamic holidays to keep app up-to-date
      for (int yearOffset = 0; yearOffset <= 2; yearOffset++) {
        try {
          final yearHolidays = await _holidayService.getHolidays(
            currentYear + yearOffset,
            language: _currentLanguage,
          );
          if (yearHolidays.isNotEmpty) {
            allHolidays.addAll(yearHolidays);
          } else {
            // If getHolidays returns empty, use fallback
            debugPrint('getHolidays returned empty for year ${currentYear + yearOffset}, using fallback');
            final fallbackHolidays = HolidayService.getFallbackHolidays(
              currentYear + yearOffset,
              language: _currentLanguage,
            );
            allHolidays.addAll(fallbackHolidays);
            final islamicHolidays = HolidayService.getIslamicHolidaysForYear(
              currentYear + yearOffset,
              language: _currentLanguage,
            );
            allHolidays.addAll(islamicHolidays);
          }
        } catch (e) {
          // If one year fails, use fallback data for that year
          debugPrint('Exception loading holidays for year ${currentYear + yearOffset}: $e, using fallback');
          try {
            final fallbackHolidays = HolidayService.getFallbackHolidays(
              currentYear + yearOffset,
              language: _currentLanguage,
            );
            allHolidays.addAll(fallbackHolidays);
            final islamicHolidays = HolidayService.getIslamicHolidaysForYear(
              currentYear + yearOffset,
              language: _currentLanguage,
            );
            allHolidays.addAll(islamicHolidays);
          } catch (fallbackError) {
            debugPrint('Error loading fallback holidays: $fallbackError');
          }
        }
      }
      
      // If no holidays were loaded (API completely failed), use fallback data
      if (allHolidays.isEmpty) {
        debugPrint('No holidays loaded from API, using fallback data');
        for (int yearOffset = 0; yearOffset <= 2; yearOffset++) {
          final fallbackHolidays = HolidayService.getFallbackHolidays(
            currentYear + yearOffset,
            language: _currentLanguage,
          );
          allHolidays.addAll(fallbackHolidays);
          
          // Add Islamic holidays
          final islamicHolidays = HolidayService.getIslamicHolidaysForYear(
            currentYear + yearOffset,
            language: _currentLanguage,
          );
          allHolidays.addAll(islamicHolidays);
        }
      }
      
      // Remove duplicates and sort
      final uniqueHolidays = <DateTime, Holiday>{};
      for (var holiday in allHolidays) {
        final dateKey = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
        // Keep the first occurrence (or prefer API data over fallback)
        if (!uniqueHolidays.containsKey(dateKey)) {
          uniqueHolidays[dateKey] = holiday;
        }
      }
      
      _holidays = uniqueHolidays.values.toList();
      _holidays.sort((a, b) => a.date.compareTo(b.date));
      
      // Clear any previous errors since we have holidays (from API or fallback)
      _error = null;
      
      // Save to cache for offline use
      await _saveCachedHolidays();
    } catch (e) {
      debugPrint('Error loading holidays: $e');
      
      // Try to load cached holidays as fallback
      await _loadCachedHolidays();
      
      // If still no holidays, use built-in fallback data
      if (_holidays.isEmpty) {
        debugPrint('No cached holidays, using built-in fallback data');
        final currentYear = DateTime.now().year;
        final allHolidays = <Holiday>[];
        for (int yearOffset = 0; yearOffset <= 2; yearOffset++) {
          final fallbackHolidays = HolidayService.getFallbackHolidays(
            currentYear + yearOffset,
            language: _currentLanguage,
          );
          allHolidays.addAll(fallbackHolidays);
          
          // Add Islamic holidays
          final islamicHolidays = HolidayService.getIslamicHolidaysForYear(
            currentYear + yearOffset,
            language: _currentLanguage,
          );
          allHolidays.addAll(islamicHolidays);
        }
        _holidays = allHolidays;
        _holidays.sort((a, b) => a.date.compareTo(b.date));
      }
      
      // Don't set error if we have fallback holidays - app can still work
      if (_holidays.isEmpty) {
        _error = 'Failed to load holidays. Please check your internet connection.';
      } else {
        _error = null; // Clear error if we have fallback data
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh holidays from API (useful for getting latest Islamic holiday dates)
  Future<void> refreshHolidays({String? language}) async {
    // Update language if provided
    if (language != null) {
      _currentLanguage = language;
    }
    
    // Always try to load holidays - will use fallback if API fails
    await _loadHolidays();
  }

  Future<void> calculateVacation({
    required DateTime startDate,
    required int requestedDays,
  }) async {
    if (requestedDays <= 0) {
      _error = 'Number of days must be greater than 0';
      notifyListeners();
      return;
    }

    if (requestedDays > remainingDays) {
      _error = 'You only have $remainingDays days remaining';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Ensure we have holidays loaded
      if (_holidays.isEmpty) {
        await _loadHolidays();
      }

      // Ensure we have holidays for the full vacation period
      // Calculate approximate end date (start + requested days + weekends/holidays buffer)
      // Add buffer of ~50% for weekends and holidays
      final estimatedEndDate = startDate.add(Duration(days: (requestedDays * 1.5).round()));
      final startYear = startDate.year;
      final endYear = estimatedEndDate.year;
      
      // Check if we need to load additional years
      final yearsNeeded = <int>{};
      for (int year = startYear; year <= endYear; year++) {
        yearsNeeded.add(year);
      }
      
      // Load missing years
      final loadedYears = _holidays.map((h) => h.date.year).toSet();
      final missingYears = yearsNeeded.where((year) => !loadedYears.contains(year)).toList();
      
      if (missingYears.isNotEmpty) {
        debugPrint('Loading additional holidays for years: $missingYears');
        final additionalHolidays = <Holiday>[];
        for (final year in missingYears) {
          try {
            final yearHolidays = await _holidayService.getHolidays(
              year,
              language: _currentLanguage,
            );
            additionalHolidays.addAll(yearHolidays);
          } catch (e) {
            debugPrint('Failed to load holidays for year $year: $e');
          }
        }
        
        // Merge with existing holidays
        final allHolidays = <DateTime, Holiday>{};
        for (var holiday in _holidays) {
          final dateKey = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
          allHolidays[dateKey] = holiday;
        }
        for (var holiday in additionalHolidays) {
          final dateKey = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
          if (!allHolidays.containsKey(dateKey)) {
            allHolidays[dateKey] = holiday;
          }
        }
        
        _holidays = allHolidays.values.toList();
        _holidays.sort((a, b) => a.date.compareTo(b.date));
        
        // Save updated holidays to cache
        await _saveCachedHolidays();
      }

      _currentCalculation = VacationCalculator.calculateReturnDate(
        startDate: startDate,
        requestedWorkingDays: requestedDays,
        holidays: _holidays,
      );
      
      // Debug: Log holidays found in the vacation period
      final vacationHolidays = _holidays.where((h) {
        final holidayDate = DateTime(h.date.year, h.date.month, h.date.day);
        return holidayDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
               holidayDate.isBefore(_currentCalculation!.returnDate.add(const Duration(days: 1)));
      }).toList();
      debugPrint('=== Vacation Calculation Debug ===');
      debugPrint('Start date: ${startDate.toIso8601String()}');
      debugPrint('Return date: ${_currentCalculation!.returnDate.toIso8601String()}');
      debugPrint('Total holidays loaded: ${_holidays.length}');
      debugPrint('Holidays by year:');
      final holidaysByYear = <int, int>{};
      for (var h in _holidays) {
        holidaysByYear[h.date.year] = (holidaysByYear[h.date.year] ?? 0) + 1;
      }
      for (var entry in holidaysByYear.entries) {
        debugPrint('  Year ${entry.key}: ${entry.value} holidays');
      }
      debugPrint('Holidays in vacation period (from provider): ${vacationHolidays.length}');
      for (var h in vacationHolidays) {
        debugPrint('  - ${h.date.toIso8601String()}: ${h.name}');
      }
      debugPrint('Holidays in calculation result: ${_currentCalculation!.holidays.length}');
      for (var h in _currentCalculation!.holidays) {
        debugPrint('  - ${h.toIso8601String()}');
      }
      debugPrint('Holiday days count: ${_currentCalculation!.holidayDays}');
      debugPrint('===============================');
    } catch (e) {
      _error = 'Calculation error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmVacation() async {
    if (_currentCalculation == null) return;

    _usedDays += _currentCalculation!.requestedDays;
    _history.add(_currentCalculation!);
    await _saveData();
    notifyListeners();
  }

  void clearCurrentCalculation() {
    _currentCalculation = null;
    _error = null;
    notifyListeners();
  }

  Future<void> resetYear() async {
    _usedDays = 0;
    _history.clear();
    _currentCalculation = null;
    await _saveData();
    notifyListeners();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalAnnualDays = prefs.getInt('totalAnnualDays') ?? 22;
      _usedDays = prefs.getInt('usedDays') ?? 0;
      
      final historyJson = prefs.getString('history');
      if (historyJson != null) {
        final List<dynamic> decoded = json.decode(historyJson);
        _history = decoded.map((item) => VacationCalculation.fromJson(item)).toList();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('totalAnnualDays', _totalAnnualDays);
      await prefs.setInt('usedDays', _usedDays);
      
      final historyJson = json.encode(_history.map((calc) => calc.toJson()).toList());
      await prefs.setString('history', historyJson);
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  Future<void> updateTotalAnnualDays(int newTotal) async {
    if (newTotal < 1) {
      _error = 'Total days must be at least 1';
      notifyListeners();
      return;
    }
    
    if (newTotal < _usedDays) {
      _error = 'Total days cannot be less than used days ($_usedDays)';
      notifyListeners();
      return;
    }
    
    _totalAnnualDays = newTotal;
    await _saveData();
    _error = null;
    notifyListeners();
  }

  Future<void> deleteHistoryItem(int index) async {
    if (index >= 0 && index < _history.length) {
      final calculation = _history[index];
      _usedDays -= calculation.requestedDays;
      _history.removeAt(index);
      await _saveData();
      notifyListeners();
    }
  }
}

