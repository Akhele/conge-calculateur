import 'package:flutter_test/flutter_test.dart';
import 'package:conge_calculateur/services/vacation_calculator.dart';
import 'package:conge_calculateur/models/holiday.dart';

void main() {
  group('VacationCalculator', () {
    test('calculates return date with weekends', () {
      // Request 5 working days starting Monday
      final startDate = DateTime(2024, 1, 8); // Monday, January 8, 2024
      final holidays = <Holiday>[];

      final result = VacationCalculator.calculateReturnDate(
        startDate: startDate,
        requestedWorkingDays: 5,
        holidays: holidays,
      );

      // Should skip weekend (13-14) and return on Monday, January 15
      expect(result.returnDate, DateTime(2024, 1, 15));
      expect(result.requestedDays, 5);
      expect(result.weekendDays, 2); // Saturday and Sunday
      expect(result.totalCalendarDays, 7); // 5 working + 2 weekend
    });

    test('calculates return date with holidays', () {
      // Request 5 working days starting Monday with a holiday on Wednesday
      final startDate = DateTime(2024, 1, 8); // Monday
      final holidays = [
        Holiday(
          date: DateTime(2024, 1, 10), // Wednesday
          name: 'Test Holiday',
          nameAr: 'عطلة اختبار',
          type: 'public',
        ),
      ];

      final result = VacationCalculator.calculateReturnDate(
        startDate: startDate,
        requestedWorkingDays: 5,
        holidays: holidays,
      );

      // Should skip weekend (13-14) and holiday (10) and return on Tuesday, January 16
      expect(result.returnDate, DateTime(2024, 1, 16));
      expect(result.requestedDays, 5);
      expect(result.weekendDays, 2);
      expect(result.holidayDays, 1);
      expect(result.totalCalendarDays, 8); // 5 working + 2 weekend + 1 holiday
    });

    test('handles vacation starting on Friday', () {
      // Request 5 working days starting Friday
      final startDate = DateTime(2024, 1, 12); // Friday
      final holidays = <Holiday>[];

      final result = VacationCalculator.calculateReturnDate(
        startDate: startDate,
        requestedWorkingDays: 5,
        holidays: holidays,
      );

      // Friday (12), skip weekend (13-14), Mon-Thu (15-18), return Friday (19)
      expect(result.returnDate, DateTime(2024, 1, 19));
      expect(result.requestedDays, 5);
      expect(result.weekendDays, 2); // One weekend
    });

    test('calculates working days between dates', () {
      final start = DateTime(2024, 1, 8); // Monday
      final end = DateTime(2024, 1, 15); // Monday (next week)
      final holidays = <Holiday>[];

      final workingDays = VacationCalculator.getWorkingDaysBetween(
        start: start,
        end: end,
        holidays: holidays,
      );

      // Mon-Fri (5 days) of first week
      expect(workingDays, 5);
    });

    test('excludes holidays from working days count', () {
      final start = DateTime(2024, 1, 8); // Monday
      final end = DateTime(2024, 1, 15); // Monday (next week)
      final holidays = [
        Holiday(
          date: DateTime(2024, 1, 10), // Wednesday
          name: 'Test Holiday',
          nameAr: 'عطلة اختبار',
          type: 'public',
        ),
      ];

      final workingDays = VacationCalculator.getWorkingDaysBetween(
        start: start,
        end: end,
        holidays: holidays,
      );

      // Mon-Fri (5 days) minus 1 holiday = 4 working days
      expect(workingDays, 4);
    });
  });
}

