import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  // Annual leave tracking
  final int _totalAnnualDays = 22;
  int _usedDays = 0;
  List<VacationCalculation> _history = [];

  List<Holiday> get holidays => _holidays;
  VacationCalculation? get currentCalculation => _currentCalculation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalAnnualDays => _totalAnnualDays;
  int get usedDays => _usedDays;
  int get remainingDays => _totalAnnualDays - _usedDays;
  List<VacationCalculation> get history => _history;

  VacationProvider() {
    _loadSavedData();
    _loadHolidays();
  }

  Future<void> _loadHolidays() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentYear = DateTime.now().year;
      final holidays = await _holidayService.getHolidays(currentYear);
      final nextYearHolidays = await _holidayService.getHolidays(currentYear + 1);
      
      _holidays = [...holidays, ...nextYearHolidays];
      _holidays.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      _error = 'Failed to load holidays: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

      _currentCalculation = VacationCalculator.calculateReturnDate(
        startDate: startDate,
        requestedWorkingDays: requestedDays,
        holidays: _holidays,
      );
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
      await prefs.setInt('usedDays', _usedDays);
      
      final historyJson = json.encode(_history.map((calc) => calc.toJson()).toList());
      await prefs.setString('history', historyJson);
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
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

