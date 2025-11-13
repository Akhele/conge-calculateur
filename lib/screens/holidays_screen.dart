import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';
import '../services/language_provider.dart';
import '../models/holiday.dart';

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  String? _lastLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLanguage();
    });
  }

  void _updateLanguage() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final vacationProvider = Provider.of<VacationProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLanguage;
    
    if (_lastLanguage != currentLanguage) {
      _lastLanguage = currentLanguage;
      vacationProvider.setLanguage(currentLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VacationProvider, LanguageProvider>(
      builder: (context, vacationProvider, languageProvider, child) {
        // Update language when it changes
        final currentLanguage = languageProvider.currentLanguage;
        if (_lastLanguage != currentLanguage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateLanguage();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Jours Fériés au Maroc'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: [
              IconButton(
                icon: vacationProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onPressed: vacationProvider.isLoading
                    ? null
                    : () {
                        vacationProvider.refreshHolidays(
                          language: languageProvider.currentLanguage,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Actualisation des jours fériés...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                tooltip: 'Actualiser les jours fériés',
              ),
            ],
          ),
          body: _buildBody(context, vacationProvider, languageProvider),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, VacationProvider vacationProvider, LanguageProvider languageProvider) {
    if (vacationProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vacationProvider.holidays.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun jour férié disponible',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    // Get current language
    final currentLanguage = languageProvider.currentLanguage;
    
    // Group holidays by year
    final holidaysByYear = <int, List<Holiday>>{};
    for (var holiday in vacationProvider.holidays) {
      holidaysByYear.putIfAbsent(holiday.date.year, () => []).add(holiday);
    }

    return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: holidaysByYear.length,
            itemBuilder: (context, yearIndex) {
              final year = holidaysByYear.keys.elementAt(yearIndex);
              final yearHolidays = holidaysByYear[year]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          year.toString(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final holiday in yearHolidays)
                    Builder(
                      builder: (context) {
                        final isPast = holiday.date.isBefore(DateTime.now());
                        final isToday = _isToday(holiday.date);
                        final isUpcoming = holiday.date.isAfter(DateTime.now()) &&
                            holiday.date.isBefore(DateTime.now().add(const Duration(days: 30)));
                        final isWeekend = _isWeekend(holiday.date);

                        return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: isToday ? 4 : 1,
                      color: isToday
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Theme.of(context).colorScheme.primary
                                    : isPast
                                        ? Colors.grey[300]
                                        : isUpcoming
                                            ? Colors.orange[100]
                                            : Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _formatDateWithWesternNumbers(holiday.date, 'd', currentLanguage),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isToday
                                          ? Colors.white
                                          : isPast
                                              ? Colors.grey[700]
                                              : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    _formatDateWithWesternNumbers(holiday.date, 'MMM', currentLanguage),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isToday
                                          ? Colors.white
                                          : isPast
                                              ? Colors.grey[600]
                                              : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display holiday name based on selected language
                                  Text(
                                    _getHolidayName(holiday, currentLanguage),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isPast ? Colors.grey[600] : null,
                                        ),
                                  ),
                                  // Show alternative language name as subtitle if different
                                  if (currentLanguage == 'ar' && holiday.name.isNotEmpty && holiday.name != holiday.nameAr)
                                    Text(
                                      holiday.name,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: isPast ? Colors.grey[500] : Colors.grey[600],
                                          ),
                                    )
                                  else if (currentLanguage != 'ar' && holiday.nameAr.isNotEmpty && holiday.nameAr != holiday.name)
                                    Text(
                                      holiday.nameAr,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: isPast ? Colors.grey[500] : Colors.grey[600],
                                          ),
                                    ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        _getHolidayIcon(holiday.type),
                                        size: 14,
                                        color: isPast
                                            ? Colors.grey[500]
                                            : Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDateWithWesternNumbers(holiday.date, 'EEEE', currentLanguage),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: isPast ? Colors.grey[500] : null,
                                            ),
                                      ),
                                      if (isWeekend) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.red[300]!, width: 1),
                                          ),
                                          child: Text(
                                            'Week-end',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.red[800],
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isToday)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Aujourd\'hui',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (isUpcoming && !isToday)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Bientôt',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                      },
                    ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
  }

  /// Get the appropriate holiday name based on the current language
  String _getHolidayName(Holiday holiday, String language) {
    if (language == 'ar' && holiday.nameAr.isNotEmpty) {
      return holiday.nameAr;
    }
    return holiday.name.isNotEmpty ? holiday.name : holiday.nameAr;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  IconData _getHolidayIcon(String type) {
    switch (type.toLowerCase()) {
      case 'religious':
        return Icons.mosque;
      case 'public':
        return Icons.flag;
      default:
        return Icons.event;
    }
  }

  /// Format date with locale but ensure numbers are Western numerals (0-9)
  String _formatDateWithWesternNumbers(DateTime date, String format, String language) {
    final locale = language == 'ar' ? 'ar' : language == 'fr' ? 'fr_FR' : 'en_US';
    final formatted = DateFormat(format, locale).format(date);
    
    // Replace Arabic-Indic numerals with Western numerals
    return formatted
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
  }
}

