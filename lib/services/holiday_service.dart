import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/holiday.dart';

class HolidayService {
  // Using Calendarific API - you'll need to get a free API key from https://calendarific.com/
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://calendarific.com/api/v2';

  // Fallback: Moroccan fixed holidays for 2024-2025
  static List<Holiday> getFallbackHolidays(int year) {
    return [
      // Fixed holidays
      Holiday(
        date: DateTime(year, 1, 1),
        name: 'New Year\'s Day',
        nameAr: 'رأس السنة الميلادية',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 1, 11),
        name: 'Independence Manifesto Day',
        nameAr: 'ذكرى تقديم وثيقة الاستقلال',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 5, 1),
        name: 'Labour Day',
        nameAr: 'عيد الشغل',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 7, 30),
        name: 'Throne Day',
        nameAr: 'عيد العرش',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 14),
        name: 'Oued Ed-Dahab Day',
        nameAr: 'ذكرى استرجاع إقليم وادي الذهب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 20),
        name: 'Revolution Day',
        nameAr: 'ثورة الملك والشعب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 21),
        name: 'Youth Day',
        nameAr: 'عيد الشباب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 11, 6),
        name: 'Green March Day',
        nameAr: 'ذكرى المسيرة الخضراء',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 11, 18),
        name: 'Independence Day',
        nameAr: 'عيد الاستقلال',
        type: 'public',
      ),
    ];
  }

  // Islamic holidays (approximate dates - these vary by moon sighting)
  static List<Holiday> getIslamicHolidays2024() {
    return [
      Holiday(
        date: DateTime(2024, 4, 10),
        name: 'Eid al-Fitr (Day 1)',
        nameAr: 'عيد الفطر - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2024, 4, 11),
        name: 'Eid al-Fitr (Day 2)',
        nameAr: 'عيد الفطر - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2024, 6, 16),
        name: 'Eid al-Adha (Day 1)',
        nameAr: 'عيد الأضحى - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2024, 6, 17),
        name: 'Eid al-Adha (Day 2)',
        nameAr: 'عيد الأضحى - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2024, 7, 7),
        name: 'Islamic New Year',
        nameAr: 'رأس السنة الهجرية',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2024, 9, 15),
        name: 'Mawlid (Prophet\'s Birthday)',
        nameAr: 'عيد المولد النبوي',
        type: 'religious',
      ),
    ];
  }

  static List<Holiday> getIslamicHolidays2025() {
    return [
      Holiday(
        date: DateTime(2025, 3, 30),
        name: 'Eid al-Fitr (Day 1)',
        nameAr: 'عيد الفطر - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2025, 3, 31),
        name: 'Eid al-Fitr (Day 2)',
        nameAr: 'عيد الفطر - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2025, 6, 6),
        name: 'Eid al-Adha (Day 1)',
        nameAr: 'عيد الأضحى - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2025, 6, 7),
        name: 'Eid al-Adha (Day 2)',
        nameAr: 'عيد الأضحى - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2025, 6, 26),
        name: 'Islamic New Year',
        nameAr: 'رأس السنة الهجرية',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2025, 9, 4),
        name: 'Mawlid (Prophet\'s Birthday)',
        nameAr: 'عيد المولد النبوي',
        type: 'religious',
      ),
    ];
  }

  Future<List<Holiday>> getHolidays(int year) async {
    try {
      // Try to fetch from API if key is configured
      if (apiKey != 'YOUR_API_KEY_HERE') {
        final response = await http.get(
          Uri.parse('$baseUrl/holidays?api_key=$apiKey&country=MA&year=$year'),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final holidays = <Holiday>[];
          
          for (var holiday in data['response']['holidays']) {
            holidays.add(Holiday(
              date: DateTime.parse(holiday['date']['iso']),
              name: holiday['name'],
              nameAr: holiday['name'], // API might not have Arabic names
              type: holiday['type'][0],
            ));
          }
          
          return holidays;
        }
      }
    } catch (e) {
      // Fall through to use fallback data
    }

    // Use fallback data
    List<Holiday> holidays = getFallbackHolidays(year);
    
    if (year == 2024) {
      holidays.addAll(getIslamicHolidays2024());
    } else if (year == 2025) {
      holidays.addAll(getIslamicHolidays2025());
    }
    
    // Sort by date
    holidays.sort((a, b) => a.date.compareTo(b.date));
    
    return holidays;
  }

  Future<List<Holiday>> getHolidaysForDateRange(DateTime start, DateTime end) async {
    final years = <int>{};
    for (var date = start; date.isBefore(end.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      years.add(date.year);
    }

    final allHolidays = <Holiday>[];
    for (var year in years) {
      final holidays = await getHolidays(year);
      allHolidays.addAll(holidays);
    }

    // Filter to only holidays within the date range
    return allHolidays.where((holiday) {
      return (holiday.date.isAfter(start.subtract(const Duration(days: 1))) &&
              holiday.date.isBefore(end.add(const Duration(days: 1))));
    }).toList();
  }
}

