import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  DateTime _selectedDate = DateTime.now();
  int _requestedDays = 5;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _daysController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _daysController.text = _requestedDays.toString();
  }
  
  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controller when remaining days change (e.g., after settings change)
    final provider = Provider.of<VacationProvider>(context, listen: false);
    if (_requestedDays > provider.remainingDays) {
      _requestedDays = provider.remainingDays;
      _daysController.text = _requestedDays.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).calculateVacationTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<VacationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context).workingDaysAvailable,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${provider.remainingDays} ${AppLocalizations.of(context).days}',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Les week-ends et jours fériés sont automatiquement ajoutés',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Start date picker
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date de début',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('EEEE', 'fr_FR').format(_selectedDate),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        Text(
                                          DateFormat('d MMMM yyyy', 'fr_FR').format(_selectedDate),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Number of days
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).numberOfWorkingDays,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _requestedDays > 1
                                    ? () {
                                        setState(() {
                                          _requestedDays--;
                                          _daysController.text = _requestedDays.toString();
                                        });
                                      }
                                    : null,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  onChanged: (value) {
                                    final numValue = int.tryParse(value);
                                    if (numValue != null) {
                                      final clampedValue = numValue.clamp(1, provider.remainingDays);
                                      if (clampedValue != numValue) {
                                        _daysController.text = clampedValue.toString();
                                        _daysController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: _daysController.text.length),
                                        );
                                      }
                                      setState(() {
                                        _requestedDays = clampedValue;
                                      });
                                    } else if (value.isEmpty) {
                                      // Allow empty temporarily while typing
                                    }
                                  },
                                  onSubmitted: (value) {
                                    final numValue = int.tryParse(value);
                                    if (numValue == null || numValue < 1) {
                                      _daysController.text = '1';
                                      setState(() => _requestedDays = 1);
                                    } else {
                                      final clampedValue = numValue.clamp(1, provider.remainingDays);
                                      _daysController.text = clampedValue.toString();
                                      setState(() => _requestedDays = clampedValue);
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: _requestedDays < provider.remainingDays
                                    ? () {
                                        setState(() {
                                          _requestedDays++;
                                          _daysController.text = _requestedDays.toString();
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.add_circle_outline),
                                iconSize: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context).workingDaysOnly,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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

                  // Calculate button
                  FilledButton.icon(
                    onPressed: () => _calculate(context, provider),
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculer'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _calculate(BuildContext context, VacationProvider provider) async {
    if (_formKey.currentState!.validate()) {
      await provider.calculateVacation(
        startDate: _selectedDate,
        requestedDays: _requestedDays,
      );

      if (provider.error == null && provider.currentCalculation != null) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultScreen(),
            ),
          );
        }
      }
    }
  }
}

