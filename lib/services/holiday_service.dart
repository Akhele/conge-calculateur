import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/holiday.dart';
import '../config/api_keys.dart';

class HolidayService {
  // Using Calendarific API - get a free API key from https://calendarific.com/
  // Configure your API key in lib/config/api_keys.dart
  static const String apiKey = ApiKeys.calendarificApiKey;
  static const String baseUrl = 'https://calendarific.com/api/v2';

  // Fallback: Moroccan fixed holidays for 2024-2025
  // Returns holidays with names in the requested language (or English as default)
  static List<Holiday> getFallbackHolidays(int year, {String? language}) {
    // French translations for Moroccan holidays
    final Map<String, String> frenchNames = {
      'New Year\'s Day': 'Jour de l\'An',
      'Independence Manifesto Day': 'Fête du Manifeste de l\'Indépendance',
      'Labour Day': 'Fête du Travail',
      'Throne Day': 'Fête du Trône',
      'Oued Ed-Dahab Day': 'Fête de Oued Ed-Dahab',
      'Revolution Day': 'Fête de la Révolution du Roi et du Peuple',
      'Youth Day': 'Fête de la Jeunesse',
      'Green March Day': 'Fête de la Marche Verte',
      'Independence Day': 'Fête de l\'Indépendance',
      'Eid al-Fitr (Day 1)': 'Aïd el-Fitr (Jour 1)',
      'Eid al-Fitr (Day 2)': 'Aïd el-Fitr (Jour 2)',
      'Eid al-Adha (Day 1)': 'Aïd el-Adha (Jour 1)',
      'Eid al-Adha (Day 2)': 'Aïd el-Adha (Jour 2)',
      'Islamic New Year': 'Ras as-Sana (Nouvel An islamique)',
      'Mawlid (Prophet\'s Birthday)': 'Mawlid (Anniversaire du Prophète)',
      'Amazigh New Year': 'فاتح السنة الأمازيغية',
      'Unity Day': 'عيد الوحدة',
    };
    
    final holidays = [
      // Fixed holidays
      Holiday(
        date: DateTime(year, 1, 1),
        name: language == 'fr' ? frenchNames['New Year\'s Day']! : 'New Year\'s Day',
        nameAr: 'رأس السنة الميلادية',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 1, 11),
        name: language == 'fr' ? frenchNames['Independence Manifesto Day']! : 'Independence Manifesto Day',
        nameAr: 'ذكرى تقديم وثيقة الاستقلال',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 5, 1),
        name: language == 'fr' ? frenchNames['Labour Day']! : 'Labour Day',
        nameAr: 'عيد الشغل',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 7, 30),
        name: language == 'fr' ? frenchNames['Throne Day']! : 'Throne Day',
        nameAr: 'عيد العرش',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 14),
        name: language == 'fr' ? frenchNames['Oued Ed-Dahab Day']! : 'Oued Ed-Dahab Day',
        nameAr: 'ذكرى استرجاع إقليم وادي الذهب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 20),
        name: language == 'fr' ? frenchNames['Revolution Day']! : 'Revolution Day',
        nameAr: 'ثورة الملك والشعب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 8, 21),
        name: language == 'fr' ? frenchNames['Youth Day']! : 'Youth Day',
        nameAr: 'عيد الشباب',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 11, 6),
        name: language == 'fr' ? frenchNames['Green March Day']! : 'Green March Day',
        nameAr: 'ذكرى المسيرة الخضراء',
        type: 'public',
      ),
      Holiday(
        date: DateTime(year, 11, 18),
        name: language == 'fr' ? frenchNames['Independence Day']! : 'Independence Day',
        nameAr: 'عيد الاستقلال',
        type: 'public',
      ),
      // Amazigh New Year - January 14
      Holiday(
        date: DateTime(year, 1, 14),
        name: language == 'ar' 
            ? 'فاتح السنة الأمازيغية'
            : language == 'fr'
                ? 'Nouvel An amazigh'
                : 'Amazigh New Year',
        nameAr: 'فاتح السنة الأمازيغية',
        type: 'public',
      ),
      // Unity Day - October 31
      Holiday(
        date: DateTime(year, 10, 31),
        name: language == 'ar'
            ? 'عيد الوحدة'
            : language == 'fr'
                ? 'Journée de l\'Unité'
                : 'Unity Day',
        nameAr: 'عيد الوحدة',
        type: 'public',
      ),
    ];
    
    return holidays;
  }

  // Helper method to get Islamic holidays for any year
  // Islamic holidays shift ~10-11 days earlier each year (lunar calendar)
  static List<Holiday> getIslamicHolidaysForYear(int year, {String? language}) {
    List<Holiday> holidays;
    if (year == 2024) {
      holidays = getIslamicHolidays2024();
    } else if (year == 2025) {
      holidays = getIslamicHolidays2025();
    } else if (year == 2026) {
      holidays = getIslamicHolidays2026();
    } else if (year == 2027) {
      holidays = getIslamicHolidays2027();
    } else if (year == 2028) {
      holidays = getIslamicHolidays2028();
    } else if (year > 2028) {
      // For years beyond 2028, calculate approximate dates based on 2024
      holidays = _calculateIslamicHolidaysForYear(year);
    } else {
      return [];
    }
    
    // Apply French translations if language is French
    if (language == 'fr') {
      final Map<String, String> frenchNames = {
        'Eid al-Fitr (Day 1)': 'Aïd el-Fitr (Jour 1)',
        'Eid al-Fitr (Day 2)': 'Aïd el-Fitr (Jour 2)',
        'Eid al-Adha (Day 1)': 'Aïd el-Adha (Jour 1)',
        'Eid al-Adha (Day 2)': 'Aïd el-Adha (Jour 2)',
        'Islamic New Year': 'Ras as-Sana (Nouvel An islamique)',
        'Mawlid (Prophet\'s Birthday)': 'Mawlid (Anniversaire du Prophète)',
      };
      
      return holidays.map((holiday) {
        final frenchName = frenchNames[holiday.name] ?? holiday.name;
        return Holiday(
          date: holiday.date,
          name: frenchName,
          nameAr: holiday.nameAr,
          type: holiday.type,
        );
      }).toList();
    }
    
    return holidays;
  }

  // Calculate approximate Islamic holidays for years beyond 2028
  static List<Holiday> _calculateIslamicHolidaysForYear(int year) {
    const baseYear = 2024;
    final yearDiff = year - baseYear;
    // Approximate shift: 10-11 days earlier per year
    final daysShift = yearDiff * -11;
    
    final baseHolidays = getIslamicHolidays2024();
    return baseHolidays.map((holiday) {
      final newDate = holiday.date.add(Duration(days: daysShift));
      return Holiday(
        date: newDate,
        name: holiday.name,
        nameAr: holiday.nameAr,
        type: holiday.type,
      );
    }).toList();
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

  static List<Holiday> getIslamicHolidays2026() {
    return [
      Holiday(
        date: DateTime(2026, 3, 20),
        name: 'Eid al-Fitr (Day 1)',
        nameAr: 'عيد الفطر - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2026, 3, 21),
        name: 'Eid al-Fitr (Day 2)',
        nameAr: 'عيد الفطر - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2026, 5, 26),
        name: 'Eid al-Adha (Day 1)',
        nameAr: 'عيد الأضحى - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2026, 5, 27),
        name: 'Eid al-Adha (Day 2)',
        nameAr: 'عيد الأضحى - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2026, 6, 15),
        name: 'Islamic New Year',
        nameAr: 'رأس السنة الهجرية',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2026, 8, 24),
        name: 'Mawlid (Prophet\'s Birthday)',
        nameAr: 'عيد المولد النبوي',
        type: 'religious',
      ),
    ];
  }

  static List<Holiday> getIslamicHolidays2027() {
    return [
      Holiday(
        date: DateTime(2027, 3, 9),
        name: 'Eid al-Fitr (Day 1)',
        nameAr: 'عيد الفطر - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2027, 3, 10),
        name: 'Eid al-Fitr (Day 2)',
        nameAr: 'عيد الفطر - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2027, 5, 15),
        name: 'Eid al-Adha (Day 1)',
        nameAr: 'عيد الأضحى - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2027, 5, 16),
        name: 'Eid al-Adha (Day 2)',
        nameAr: 'عيد الأضحى - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2027, 6, 4),
        name: 'Islamic New Year',
        nameAr: 'رأس السنة الهجرية',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2027, 8, 13),
        name: 'Mawlid (Prophet\'s Birthday)',
        nameAr: 'عيد المولد النبوي',
        type: 'religious',
      ),
    ];
  }

  static List<Holiday> getIslamicHolidays2028() {
    return [
      Holiday(
        date: DateTime(2028, 2, 27),
        name: 'Eid al-Fitr (Day 1)',
        nameAr: 'عيد الفطر - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2028, 2, 28),
        name: 'Eid al-Fitr (Day 2)',
        nameAr: 'عيد الفطر - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2028, 5, 4),
        name: 'Eid al-Adha (Day 1)',
        nameAr: 'عيد الأضحى - اليوم 1',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2028, 5, 5),
        name: 'Eid al-Adha (Day 2)',
        nameAr: 'عيد الأضحى - اليوم 2',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2028, 5, 23),
        name: 'Islamic New Year',
        nameAr: 'رأس السنة الهجرية',
        type: 'religious',
      ),
      Holiday(
        date: DateTime(2028, 8, 2),
        name: 'Mawlid (Prophet\'s Birthday)',
        nameAr: 'عيد المولد النبوي',
        type: 'religious',
      ),
    ];
  }

  Future<List<Holiday>> getHolidays(int year, {String? language}) async {
    try {
      // Try to fetch from API if key is configured
      if (apiKey != 'YOUR_API_KEY_HERE') {
        // Build URL with optional language parameter
        // Calendarific API supports: en, ar, fr, etc.
        // Note: Some APIs use 'language' instead of 'lang', but Calendarific uses 'lang'
        String url = '$baseUrl/holidays?api_key=$apiKey&country=MA&year=$year&type=national,religious';
        if (language != null && language.isNotEmpty) {
          // Calendarific API expects ISO 639-1 language codes: 'ar', 'fr', 'en'
          // Note: Some APIs might not support all languages for all countries
          // If French is not supported for Morocco, API will return English as fallback
          url += '&lang=$language';
          debugPrint('Fetching holidays with language parameter: lang=$language');
        } else {
          debugPrint('Fetching holidays without language parameter (default: English)');
        }
        
        debugPrint('API URL: $url');
        
        final response = await http.get(
          Uri.parse(url),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final holidays = <Holiday>[];
          
          // Verify we got Morocco data
          if (data['response']['country']['id'] != 'ma') {
            throw Exception('Wrong country data received');
          }
          
          // Debug: Log API response structure for first holiday (to understand the format)
          if (data['response']['holidays'].isNotEmpty) {
            final firstHoliday = data['response']['holidays'][0];
            debugPrint('Sample API holiday structure: ${firstHoliday.keys}');
            debugPrint('Sample holiday data: name=${firstHoliday['name']}, name_ar=${firstHoliday['name_ar']}');
          }
          
          // Process all holidays from API (both national and religious)
          for (var holiday in data['response']['holidays']) {
            final types = holiday['type'] as List<dynamic>;
            final typeString = types.isNotEmpty ? types[0].toString() : 'public';
            final isReligious = typeString.toLowerCase().contains('religious');
            final isNational = typeString.toLowerCase().contains('national');
            
            // Always include religious holidays (Islamic holidays)
            // For national holidays, only include if location is 'All' or null (nationwide)
            final locations = holiday['locations'];
            final shouldInclude = isReligious 
                ? true // Always include religious/Islamic holidays from API
                : (isNational && (locations == 'All' || 
                   locations == null ||
                   (locations is String && locations == 'All')));
            
            if (shouldInclude) {
              // Get the name from API - when lang parameter is set, API returns localized name in 'name' field
              // Calendarific API: when lang=fr, returns French names in 'name' field
              //                  when lang=ar, returns Arabic names in 'name' field  
              //                  when lang=en or no lang, returns English names in 'name' field
              final apiName = holiday['name'] ?? '';
              
              // Some APIs also provide 'name_ar' field for Arabic specifically
              final nameAr = holiday['name_ar'] ?? '';
              
              // Store names based on what the API returned
              // The 'name' field contains the localized name based on the lang parameter
              // For display: we'll use 'name' for the requested language, 'nameAr' for Arabic fallback
              String finalName = apiName;
              String finalNameAr = nameAr.isNotEmpty ? nameAr : apiName;
              
              // If API returned Arabic in name field (when lang=ar), store it appropriately
              if (language == 'ar' && apiName.isNotEmpty) {
                // API returned Arabic in name field
                finalNameAr = apiName;
                // Try to get English fallback if available, otherwise use Arabic
                finalName = nameAr.isNotEmpty ? nameAr : apiName;
              } else {
                // For other languages (fr, en), API returns localized name in 'name' field
                finalName = apiName;
                // Keep Arabic name if available, otherwise use the name as fallback
                finalNameAr = nameAr.isNotEmpty ? nameAr : apiName;
              }
              
              // Debug: Log what we're getting from API
              if (language != null && language.isNotEmpty) {
                debugPrint('Holiday API - lang=$language, API name="$apiName", API name_ar="$nameAr" -> stored name="$finalName", nameAr="$finalNameAr"');
              }
              
              holidays.add(Holiday(
                date: DateTime.parse(holiday['date']['iso']),
                name: finalName,
                nameAr: finalNameAr,
                type: typeString,
              ));
            }
          }
          
          // Debug: Log how many holidays we got from API
          debugPrint('API returned ${holidays.length} holidays for year $year');
          final religiousCount = holidays.where((h) => h.type.toLowerCase().contains('religious')).length;
          debugPrint('  - Religious holidays: $religiousCount');
          debugPrint('  - National holidays: ${holidays.length - religiousCount}');
          
          // Check if API returned the required Moroccan holidays (January 14 and October 31)
          // If not, add them manually
          final apiDates = holidays.map((h) => DateTime(h.date.year, h.date.month, h.date.day)).toSet();
          
          // Amazigh New Year - January 14
          final amazighNewYearDate = DateTime(year, 1, 14);
          if (!apiDates.contains(amazighNewYearDate)) {
            debugPrint('API did not return Amazigh New Year (Jan 14), adding manually');
            String amazighName;
            if (language == 'ar') {
              amazighName = 'فاتح السنة الأمازيغية';
            } else if (language == 'fr') {
              amazighName = 'Nouvel An amazigh';
            } else {
              amazighName = 'Amazigh New Year';
            }
            holidays.add(Holiday(
              date: amazighNewYearDate,
              name: amazighName,
              nameAr: 'فاتح السنة الأمازيغية',
              type: 'public',
            ));
          } else {
            debugPrint('API returned Amazigh New Year (Jan 14)');
          }
          
          // Unity Day - October 31
          final unityDayDate = DateTime(year, 10, 31);
          if (!apiDates.contains(unityDayDate)) {
            debugPrint('API did not return Unity Day (Oct 31), adding manually');
            String unityName;
            if (language == 'ar') {
              unityName = 'عيد الوحدة';
            } else if (language == 'fr') {
              unityName = 'Journée de l\'Unité';
            } else {
              unityName = 'Unity Day';
            }
            holidays.add(Holiday(
              date: unityDayDate,
              name: unityName,
              nameAr: 'عيد الوحدة',
              type: 'public',
            ));
          } else {
            debugPrint('API returned Unity Day (Oct 31)');
          }
          
          // Update apiDates set after adding missing holidays
          apiDates.clear();
          for (var h in holidays) {
            apiDates.add(DateTime(h.date.year, h.date.month, h.date.day));
          }
          
          // Always merge with Islamic holidays from fallback data
          // This ensures we have Islamic holidays even if API doesn't return them
          // or for future years that aren't in fallback data yet
          final islamicHolidays = getIslamicHolidaysForYear(year, language: language);
          
          // Add Islamic holidays that aren't already in the API results by date
          // This way we always have Islamic holidays, but prefer API dates when available
          for (var islamicHoliday in islamicHolidays) {
            final islamicDate = DateTime(
              islamicHoliday.date.year, 
              islamicHoliday.date.month, 
              islamicHoliday.date.day
            );
            
            // Only check by date - if API has a holiday on this date, skip it
            // Otherwise, add our fallback Islamic holiday
            if (!apiDates.contains(islamicDate)) {
              holidays.add(islamicHoliday);
            }
          }
          
          // Sort by date
          holidays.sort((a, b) => a.date.compareTo(b.date));
          
          return holidays;
        }
      }
    } catch (e) {
      // Fall through to use fallback data
    }

    // Use fallback data (when API fails or no API key)
    List<Holiday> holidays = getFallbackHolidays(year, language: language);
    
    // Always add Islamic holidays using the helper method
    // This ensures we have Islamic holidays for all years (2024-2028+)
    final islamicHolidays = getIslamicHolidaysForYear(year, language: language);
    holidays.addAll(islamicHolidays);
    
    // Sort by date
    holidays.sort((a, b) => a.date.compareTo(b.date));
    
    return holidays;
  }

  Future<List<Holiday>> getHolidaysForDateRange(DateTime start, DateTime end, {String? language}) async {
    final years = <int>{};
    for (var date = start; date.isBefore(end.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      years.add(date.year);
    }

    final allHolidays = <Holiday>[];
    for (var year in years) {
      final holidays = await getHolidays(year, language: language);
      allHolidays.addAll(holidays);
    }

    // Filter to only holidays within the date range
    return allHolidays.where((holiday) {
      return (holiday.date.isAfter(start.subtract(const Duration(days: 1))) &&
              holiday.date.isBefore(end.add(const Duration(days: 1))));
    }).toList();
  }
}

