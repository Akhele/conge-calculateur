import '../models/vacation_calculation.dart';
import '../models/holiday.dart';

class VacationCalculator {
  /// Calculate the return date based on requested working days
  /// 
  /// Rules:
  /// - Only working days (Mon-Fri, excluding holidays) count toward the requested days
  /// - Weekends are automatically added and don't count
  /// - Public holidays are automatically added and don't count
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

    // Create a set of holiday dates for quick lookup
    final holidayDates = holidays.map((h) {
      return DateTime(h.date.year, h.date.month, h.date.day);
    }).toSet();

    // Count working days until we reach the requested amount
    while (workingDaysUsed < requestedWorkingDays) {
      // Check if current date is a weekend
      if (_isWeekend(currentDate)) {
        weekendDays++;
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }

      // Check if current date is a holiday
      if (holidayDates.contains(currentDate)) {
        holidayDays++;
        holidaysInRange.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }

      // It's a working day
      workingDaysUsed++;
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Continue adding days until we hit a working day (skip trailing weekends/holidays)
    while (_isWeekend(currentDate) || holidayDates.contains(currentDate)) {
      if (_isWeekend(currentDate)) {
        weekendDays++;
      } else if (holidayDates.contains(currentDate)) {
        holidayDays++;
        holidaysInRange.add(currentDate);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // The return date is the current date (first working day after vacation)
    final returnDate = currentDate;
    final totalCalendarDays = returnDate.difference(startDate).inDays;

    return VacationCalculation(
      startDate: startDate,
      requestedDays: requestedWorkingDays,
      returnDate: returnDate,
      totalCalendarDays: totalCalendarDays,
      weekendDays: weekendDays,
      holidayDays: holidayDays,
      holidays: holidaysInRange,
    );
  }

  /// Check if a date is a weekend (Saturday or Sunday)
  static bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Get the number of working days between two dates
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

