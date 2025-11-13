import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';
import '../services/language_provider.dart';
import '../models/holiday.dart';
import '../l10n/app_localizations.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).calculationResult),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer2<VacationProvider, LanguageProvider>(
        builder: (context, provider, languageProvider, child) {
          final calculation = provider.currentCalculation;
          final currentLanguage = languageProvider.currentLanguage;
          
          if (calculation == null) {
            return Center(child: Text('Aucun calcul disponible'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Return date card
                Card(
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).returnToWorkDate,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formatDateWithWesternNumbers(calculation.returnDate, 'EEEE', currentLanguage),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          _formatDateWithWesternNumbers(calculation.returnDate, 'd MMMM yyyy', currentLanguage),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Details card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).vacationDetails,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context).startDate,
                          _formatDateWithWesternNumbers(calculation.startDate, 'd MMMM yyyy', currentLanguage),
                          Icons.play_arrow,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context).requestedWorkingDays,
                          '${calculation.requestedDays} ${AppLocalizations.of(context).days}',
                          Icons.work,
                          highlight: true,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context).weekendsIncluded,
                          '${calculation.weekendDays} ${AppLocalizations.of(context).days}',
                          Icons.weekend,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context).holidaysIncluded,
                          '${calculation.holidayDays} ${AppLocalizations.of(context).days}',
                          Icons.event,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          AppLocalizations.of(context).totalDuration,
                          '${calculation.totalCalendarDays} ${AppLocalizations.of(context).days}',
                          Icons.calendar_month,
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Holidays during vacation
                if (calculation.holidays.isNotEmpty || calculation.weekendHolidays.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.celebration,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context).holidaysDuringVacation,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Counted holidays (on weekdays)
                          for (final holiday in calculation.holidays)
                            Builder(
                              builder: (context) {
                                final holidayInfo = provider.holidays.firstWhere(
                                  (h) => h.date.year == holiday.year &&
                                         h.date.month == holiday.month &&
                                         h.date.day == holiday.day,
                                  orElse: () => provider.holidays.first,
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_formatDateWithWesternNumbers(holiday, 'd MMM', currentLanguage)} - ${_getHolidayName(holidayInfo, currentLanguage)}',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          // Weekend holidays (not counted)
                          for (final holiday in calculation.weekendHolidays)
                            Builder(
                              builder: (context) {
                                final holidayInfo = provider.holidays.firstWhere(
                                  (h) => h.date.year == holiday.year &&
                                         h.date.month == holiday.month &&
                                         h.date.day == holiday.day,
                                  orElse: () => provider.holidays.first,
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle_outlined,
                                        size: 8,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_formatDateWithWesternNumbers(holiday, 'd MMM', currentLanguage)} - ${_getHolidayName(holidayInfo, currentLanguage)}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          currentLanguage == 'ar' ? 'نهاية الأسبوع' : currentLanguage == 'fr' ? 'Week-end' : 'Weekend',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey[700],
                                                fontSize: 10,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Summary info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${AppLocalizations.of(context).youWillBeOnVacation} ${_formatDateWithWesternNumbers(calculation.startDate, 'd MMM', currentLanguage)} '
                          '${currentLanguage == 'ar' ? 'إلى' : currentLanguage == 'fr' ? 'au' : 'to'} ${_formatDateWithWesternNumbers(calculation.returnDate.subtract(const Duration(days: 1)), 'd MMM yyyy', currentLanguage)}',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                FilledButton.icon(
                  onPressed: () => _confirmVacation(context, provider),
                  icon: const Icon(Icons.check),
                  label: Text(AppLocalizations.of(context).confirmAndSave),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    provider.clearCurrentCalculation();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(AppLocalizations.of(context).modify),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: highlight
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                  color: highlight
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
          ),
        ],
      ),
    );
  }

  void _confirmVacation(BuildContext context, VacationProvider provider) {
    provider.confirmVacation();
    
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLanguage;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentLanguage == 'ar' ? 'تم حفظ الإجازة بنجاح' : currentLanguage == 'fr' ? 'Congé enregistré avec succès' : 'Vacation saved successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to home
    Navigator.popUntil(context, (route) => route.isFirst);
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

