import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';
import '../services/language_provider.dart';
import '../models/holiday.dart';
import '../services/holiday_service.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vacationHistory),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer2<VacationProvider, LanguageProvider>(
        builder: (context, provider, languageProvider, child) {
          final currentLanguage = languageProvider.currentLanguage;
          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).noVacationsRecorded,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).confirmedVacationsWillAppearHere,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final calculation = provider.history[provider.history.length - 1 - index];
              final isPast = calculation.returnDate.isBefore(DateTime.now());
              final isOngoing = calculation.startDate.isBefore(DateTime.now()) &&
                  calculation.returnDate.isAfter(DateTime.now());

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _showDetailsDialog(context, calculation, provider, currentLanguage),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isOngoing
                                    ? Colors.green[100]
                                    : isPast
                                        ? Colors.grey[200]
                                        : Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isOngoing
                                    ? Icons.beach_access
                                    : isPast
                                        ? Icons.check_circle
                                        : Icons.upcoming,
                                color: isOngoing
                                    ? Colors.green[700]
                                    : isPast
                                        ? Colors.grey[700]
                                        : Colors.blue[700],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${calculation.requestedDays} ${AppLocalizations.of(context).workingDays}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    isOngoing
                                        ? AppLocalizations.of(context).ongoing
                                        : isPast
                                            ? AppLocalizations.of(context).completed
                                            : AppLocalizations.of(context).upcoming,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: isOngoing
                                              ? Colors.green[700]
                                              : isPast
                                                  ? Colors.grey[600]
                                                  : Colors.blue[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red[400],
                              onPressed: () => _showDeleteDialog(
                                context,
                                provider,
                                provider.history.length - 1 - index,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateInfo(
                                context,
                                AppLocalizations.of(context).startDate,
                                calculation.startDate,
                                Icons.play_arrow,
                                currentLanguage,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildDateInfo(
                                context,
                                AppLocalizations.of(context).returnToWorkDate,
                                calculation.returnDate,
                                Icons.work,
                                currentLanguage,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatChip(
                                context,
                                '${calculation.totalCalendarDays}j',
                                AppLocalizations.of(context).total,
                              ),
                              _buildStatChip(
                                context,
                                '${calculation.weekendDays}',
                                AppLocalizations.of(context).weekendsIncluded,
                              ),
                              _buildStatChip(
                                context,
                                '${calculation.holidayDays}',
                                AppLocalizations.of(context).holidaysIncluded,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, String label, DateTime date, IconData icon, String language) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          _formatDateWithWesternNumbers(date, 'd MMM', language),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context, calculation, VacationProvider provider, String language) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).vacationDetails),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(AppLocalizations.of(context).startDate, _formatDateWithWesternNumbers(calculation.startDate, 'd MMMM yyyy', language)),
              _buildDetailRow(AppLocalizations.of(context).returnToWorkDate, _formatDateWithWesternNumbers(calculation.returnDate, 'd MMMM yyyy', language)),
              _buildDetailRow(AppLocalizations.of(context).requestedWorkingDays, '${calculation.requestedDays} ${AppLocalizations.of(context).days}'),
              _buildDetailRow(AppLocalizations.of(context).totalDuration, '${calculation.totalCalendarDays} ${AppLocalizations.of(context).days}'),
              _buildDetailRow(AppLocalizations.of(context).weekendsIncluded, '${calculation.weekendDays} ${AppLocalizations.of(context).days}'),
              _buildDetailRow(AppLocalizations.of(context).holidaysIncluded, '${calculation.holidayDays} ${AppLocalizations.of(context).days}'),
              // Show holidays if available
              if (calculation.holidays.isNotEmpty || calculation.weekendHolidays.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context).holidaysDuringVacation}:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...calculation.holidays.map((holidayDate) {
                  // Try to find holiday in provider's list first
                  Holiday? holidayInfo;
                  try {
                    holidayInfo = provider.holidays.firstWhere(
                      (h) => h.date.year == holidayDate.year &&
                             h.date.month == holidayDate.month &&
                             h.date.day == holidayDate.day,
                    );
                  } catch (e) {
                    // If not found, get from fallback data with current language
                    holidayInfo = _getHolidayFromFallback(holidayDate, language);
                  }
                  
                  if (holidayInfo == null) {
                    return const SizedBox.shrink();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${_formatDateWithWesternNumbers(holidayDate, 'd MMM', language)} - ${_getHolidayName(holidayInfo, language)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }),
                ...calculation.weekendHolidays.map((holidayDate) {
                  // Try to find holiday in provider's list first
                  Holiday? holidayInfo;
                  try {
                    holidayInfo = provider.holidays.firstWhere(
                      (h) => h.date.year == holidayDate.year &&
                             h.date.month == holidayDate.month &&
                             h.date.day == holidayDate.day,
                    );
                  } catch (e) {
                    // If not found, get from fallback data with current language
                    holidayInfo = _getHolidayFromFallback(holidayDate, language);
                  }
                  
                  if (holidayInfo == null) {
                    return const SizedBox.shrink();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${_formatDateWithWesternNumbers(holidayDate, 'd MMM', language)} - ${_getHolidayName(holidayInfo, language)} (Week-end)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );
  }

  /// Get holiday name based on selected language
  String _getHolidayName(Holiday holiday, String language) {
    if (language == 'ar') {
      return holiday.nameAr.isNotEmpty ? holiday.nameAr : holiday.name;
    } else if (language == 'fr') {
      // For French, prefer name (which should be in French) over nameAr
      return holiday.name.isNotEmpty ? holiday.name : holiday.nameAr;
    }
    // For English or other languages, use name
    return holiday.name.isNotEmpty ? holiday.name : holiday.nameAr;
  }

  /// Get holiday from fallback data if not found in provider's list
  Holiday? _getHolidayFromFallback(DateTime holidayDate, String language) {
    try {
      final year = holidayDate.year;
      // Get fallback holidays for this year
      final fallbackHolidays = HolidayService.getFallbackHolidays(year, language: language);
      final islamicHolidays = HolidayService.getIslamicHolidaysForYear(year, language: language);
      
      // Search in fallback holidays
      for (var holiday in [...fallbackHolidays, ...islamicHolidays]) {
        if (holiday.date.year == holidayDate.year &&
            holiday.date.month == holidayDate.month &&
            holiday.date.day == holidayDate.day) {
          return holiday;
        }
      }
    } catch (e) {
      // If fallback fails, return null
    }
    return null;
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, VacationProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteVacation),
        content: Text(AppLocalizations.of(context).areYouSureDeleteVacation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              provider.deleteHistoryItem(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).vacationDeleted)),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }
}

