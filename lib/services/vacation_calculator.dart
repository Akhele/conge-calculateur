/// Service for calculating vacation return dates.
/// 
/// This class provides static methods to calculate when an employee should
/// return to work after taking a certain number of working days off.
/// 
/// The calculation considers:
/// - Only Monday-Friday are counted as working days
/// - Weekends (Saturday/Sunday) are automatically included but don't count
/// - Public holidays on weekdays are automatically included but don't count
/// - Holidays falling on weekends are tracked but not counted
import '../models/vacation_calculation.dart';
import '../models/holiday.dart';

class VacationCalculator {
  /// Calculates the return date based on requested working days.
  /// 
  /// This is the core calculation method that determines when an employee
  /// should return to work after requesting a specific number of working days off.
  /// 
  /// **Calculation Rules:**
  /// - Only working days (Mon-Fri, excluding holidays) count toward the requested days
  /// - Weekends are automatically added and don't count toward working days
  /// - Public holidays on weekdays are automatically added and don't count
  /// - Holidays falling on weekends are tracked but not counted
  /// 
  /// **Parameters:**
  /// - [startDate]: The first day of vacation
  /// - [requestedWorkingDays]: Number of working days requested (must be > 0)
  /// - [holidays]: List of holidays to consider in the calculation
  /// 
  /// **Returns:**
  /// A [VacationCalculation] object containing:
  /// - Return date (first working day after vacation)
  /// - Total calendar days
  /// - Count of weekend days
  /// - Count of holiday days
  /// - Lists of holidays in the period
  /// 
  /// **Example:**
  /// If you request 5 working days starting Monday, and there's a holiday
  /// on Wednesday, you'll return the following Monday (5 working days later).
  static VacationCalculation calculateReturnDate({
    required DateTime startDate,
    required int requestedWorkingDays,
    required List<Holiday> holidays,
  }) {
    // Normalize start date to beginning of day
    DateTime currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    int workingDaysUsed = 0;
    int weekendDays = 0;
    int holidayDays = 0;
    List<DateTime> holidaysInRange = [];
    List<DateTime> weekendHolidaysInRange = []; // Holidays that fall on weekends

    // Create a set of holiday dates for quick lookup
    // Normalize all holiday dates to beginning of day for accurate comparison
    final holidayDates = holidays.map((h) {
      return DateTime(h.date.year, h.date.month, h.date.day);
    }).toSet();
    
    // Debug: Log holidays available for checking
    print('VacationCalculator: Checking ${holidays.length} holidays');
    print('VacationCalculator: Start date: $currentDate');
    final relevantHolidays = holidays.where((h) {
      final holidayDate = DateTime(h.date.year, h.date.month, h.date.day);
      return holidayDate.isAfter(currentDate.subtract(const Duration(days: 1))) &&
             holidayDate.isBefore(currentDate.add(Duration(days: requestedWorkingDays * 2)));
    }).toList();
    print('VacationCalculator: Found ${relevantHolidays.length} holidays in potential range:');
    for (var h in relevantHolidays) {
      print('  - ${DateTime(h.date.year, h.date.month, h.date.day)}: ${h.name}');
    }

    // Count working days until we reach the requested amount
    while (workingDaysUsed < requestedWorkingDays) {
      // Normalize currentDate to beginning of day for accurate comparison
      currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      
      // Check if current date is a holiday
      if (holidayDates.contains(currentDate)) {
        if (_isWeekend(currentDate)) {
          // Holiday falls on weekend - don't count it, but track it for display
          weekendHolidaysInRange.add(currentDate);
          weekendDays++;
          print('VacationCalculator: Found weekend holiday on $currentDate (day ${currentDate.day}/${currentDate.month}/${currentDate.year}) - NOT COUNTED');
        } else {
          // Holiday falls on a weekday - count it
          holidayDays++;
          holidaysInRange.add(currentDate);
          print('VacationCalculator: Found holiday on $currentDate (day ${currentDate.day}/${currentDate.month}/${currentDate.year})');
        }
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }
      
      // Check if current date is a weekend
      if (_isWeekend(currentDate)) {
        weekendDays++;
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }

      // It's a working day
      workingDaysUsed++;
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Continue adding days until we hit a working day (skip trailing weekends/holidays)
    while (true) {
      // Normalize currentDate to beginning of day for accurate comparison
      currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      
      final isWeekend = _isWeekend(currentDate);
      final isHoliday = holidayDates.contains(currentDate);
      
      if (!isWeekend && !isHoliday) {
        // Found a working day, we're done
        break;
      }
      
      // Check holiday first
      if (isHoliday) {
        if (isWeekend) {
          // Holiday falls on weekend - don't count it, but track it for display
          weekendHolidaysInRange.add(currentDate);
          weekendDays++;
          print('VacationCalculator: Found trailing weekend holiday on $currentDate (day ${currentDate.day}/${currentDate.month}/${currentDate.year}) - NOT COUNTED');
        } else {
          // Holiday falls on a weekday - count it
          holidayDays++;
          holidaysInRange.add(currentDate);
          print('VacationCalculator: Found trailing holiday on $currentDate (day ${currentDate.day}/${currentDate.month}/${currentDate.year})');
        }
      } else if (isWeekend) {
        weekendDays++;
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    // Debug: Log final results
    print('VacationCalculator: Total holidays found: ${holidaysInRange.length}');
    print('VacationCalculator: Holiday days count: $holidayDays');
    print('VacationCalculator: Holidays in range:');
    for (var h in holidaysInRange) {
      print('  - $h');
    }

    // The return date is the current date (first working day after vacation)
    final returnDate = currentDate;
    final totalCalendarDays = returnDate.difference(startDate).inDays;

    // IMPORTANT: Double-check for any holidays we might have missed
    // Some holidays might occur during the working days but weren't counted if they
    // fell on days we already counted as working days (shouldn't happen, but let's be safe)
    // Also, ensure we capture all holidays in the actual vacation period
    final finalEndDate = returnDate.subtract(const Duration(days: 1)); // Last day of vacation
    final allHolidaysInPeriod = holidays.where((h) {
      final holidayDate = DateTime(h.date.year, h.date.month, h.date.day);
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd = DateTime(finalEndDate.year, finalEndDate.month, finalEndDate.day);
      return holidayDate.isAfter(normalizedStart.subtract(const Duration(days: 1))) &&
             holidayDate.isBefore(normalizedEnd.add(const Duration(days: 1)));
    }).toList();
    
    // Create a set of already found holidays (both counted and weekend holidays)
    final foundHolidayDates = <DateTime>{};
    foundHolidayDates.addAll(holidaysInRange.map((d) => DateTime(d.year, d.month, d.day)));
    foundHolidayDates.addAll(weekendHolidaysInRange.map((d) => DateTime(d.year, d.month, d.day)));
    
    // Add any missing holidays
    for (var holiday in allHolidaysInPeriod) {
      final holidayDate = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
      if (!foundHolidayDates.contains(holidayDate)) {
        if (_isWeekend(holidayDate)) {
          // Holiday falls on weekend - don't count it
          weekendHolidaysInRange.add(holidayDate);
          print('VacationCalculator: Found missed weekend holiday: $holidayDate - ${holiday.name} - NOT COUNTED');
        } else {
          // Holiday falls on weekday - count it
          holidaysInRange.add(holidayDate);
          holidayDays++;
          print('VacationCalculator: Found missed holiday: $holidayDate - ${holiday.name}');
        }
      }
    }
    
    // Sort holidays by date
    holidaysInRange.sort((a, b) => a.compareTo(b));
    weekendHolidaysInRange.sort((a, b) => a.compareTo(b));

    return VacationCalculation(
      startDate: startDate,
      requestedDays: requestedWorkingDays,
      returnDate: returnDate,
      totalCalendarDays: totalCalendarDays,
      weekendDays: weekendDays,
      holidayDays: holidayDays,
      holidays: holidaysInRange,
      weekendHolidays: weekendHolidaysInRange,
    );
  }

  /// Checks if a given date falls on a weekend (Saturday or Sunday).
  /// 
  /// **Parameters:**
  /// - [date]: The date to check
  /// 
  /// **Returns:**
  /// `true` if the date is Saturday or Sunday, `false` otherwise
  static bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Calculates the number of working days between two dates.
  /// 
  /// This method counts only weekdays (Monday-Friday) that are not holidays.
  /// 
  /// **Parameters:**
  /// - [start]: The start date (inclusive)
  /// - [end]: The end date (exclusive - not counted)
  /// - [holidays]: List of holidays to exclude from the count
  /// 
  /// **Returns:**
  /// The number of working days between the two dates
  /// 
  /// **Example:**
  /// If start is Monday and end is Friday, returns 4 (Mon-Thu)
  static int getWorkingDaysBetween({
    required DateTime start,
    required DateTime end,
    required List<Holiday> holidays,
  }) {
    DateTime currentDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    int workingDays = 0;

    final holidayDates = holidays.map((h) {
      return DateTime(h.date.year, h.date.month, h.date.day);
    }).toSet();

    while (currentDate.isBefore(endDate)) {
      if (!_isWeekend(currentDate) && !holidayDates.contains(currentDate)) {
        workingDays++;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return workingDays;
  }
}

