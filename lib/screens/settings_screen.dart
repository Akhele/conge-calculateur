import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vacation_provider.dart';
import '../services/language_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _daysController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<VacationProvider>(context, listen: false);
    _daysController = TextEditingController(
      text: provider.totalAnnualDays.toString(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<VacationProvider>(context, listen: false);
    if (_daysController.text != provider.totalAnnualDays.toString()) {
      _daysController.text = provider.totalAnnualDays.toString();
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer2<VacationProvider, LanguageProvider>(
        builder: (context, provider, languageProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Selection Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.language,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.selectLanguage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildLanguageOption(
                          context,
                          languageProvider,
                          'ar',
                          'العربية',
                          'Arabic',
                          '🇲🇦',
                        ),
                        const SizedBox(height: 8),
                        _buildLanguageOption(
                          context,
                          languageProvider,
                          'fr',
                          'Français',
                          'French',
                          '🇫🇷',
                        ),
                        const SizedBox(height: 8),
                        _buildLanguageOption(
                          context,
                          languageProvider,
                          'en',
                          'English',
                          'English',
                          '🇺🇸',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Info card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            l10n.configureAnnualVacationDays,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Annual days setting
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.annualVacationDays,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.totalWorkingDaysPerYear,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                final current = int.tryParse(_daysController.text) ?? provider.totalAnnualDays;
                                if (current > 1) {
                                  _daysController.text = (current - 1).toString();
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                              iconSize: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _daysController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final current = int.tryParse(_daysController.text) ?? provider.totalAnnualDays;
                                _daysController.text = (current + 1).toString();
                              },
                              icon: const Icon(Icons.add_circle_outline),
                              iconSize: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${l10n.currently}: ${provider.totalAnnualDays} ${l10n.days} | ${l10n.used}: ${provider.usedDays} ${l10n.days} | ${AppLocalizations.of(context).remainingDays}: ${provider.remainingDays} ${l10n.days}',
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error message
                if (provider.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.error!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Save button
                FilledButton.icon(
                  onPressed: () => _saveSettings(context, provider),
                  icon: const Icon(Icons.save),
                  label: Text(l10n.save),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 24),

                // Warning card
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.important,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[900],
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.reduceDaysWarning,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.orange[800],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    String languageCode,
    String nativeName,
    String englishName,
    String flag,
  ) {
    final l10n = AppLocalizations.of(context);
    final isSelected = languageProvider.currentLanguage == languageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await languageProvider.setLanguage(languageCode);
          // Update vacation provider language to reload holidays
          final vacationProvider = Provider.of<VacationProvider>(context, listen: false);
          vacationProvider.setLanguage(languageCode);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.languageChanged),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Flag
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Language Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nativeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black87,
                          ),
                    ),
                    Text(
                      englishName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                                : Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings(BuildContext context, VacationProvider provider) async {
    final l10n = AppLocalizations.of(context);
    final newTotal = int.tryParse(_daysController.text);
    
    if (newTotal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterValidNumber),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await provider.updateTotalAnnualDays(newTotal);

    if (provider.error == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsSaved),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}

