import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat du Calcul'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<VacationProvider>(
        builder: (context, provider, child) {
          final calculation = provider.currentCalculation;
          
          if (calculation == null) {
            return const Center(child: Text('Aucun calcul disponible'));
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
                          'Date de retour au travail',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          DateFormat('EEEE', 'fr_FR').format(calculation.returnDate),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          DateFormat('d MMMM yyyy', 'fr_FR').format(calculation.returnDate),
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
                          'Détails du congé',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          'Date de début',
                          DateFormat('d MMMM yyyy', 'fr_FR').format(calculation.startDate),
                          Icons.play_arrow,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          'Jours ouvrables demandés',
                          '${calculation.requestedDays} jours',
                          Icons.work,
                          highlight: true,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          'Week-ends inclus',
                          '${calculation.weekendDays} jours',
                          Icons.weekend,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          'Jours fériés inclus',
                          '${calculation.holidayDays} jours',
                          Icons.event,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          'Durée totale',
                          '${calculation.totalCalendarDays} jours',
                          Icons.calendar_month,
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Holidays during vacation
                if (calculation.holidays.isNotEmpty)
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
                                'Jours fériés pendant votre congé',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
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
                                          '${DateFormat('d MMM', 'fr_FR').format(holiday)} - ${holidayInfo.name}',
                                          style: Theme.of(context).textTheme.bodyMedium,
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
                          'Vous serez en congé du ${DateFormat('d MMM', 'fr_FR').format(calculation.startDate)} '
                          'au ${DateFormat('d MMM yyyy', 'fr_FR').format(calculation.returnDate.subtract(const Duration(days: 1)))}',
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
                  label: const Text('Confirmer et Enregistrer'),
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
                  label: const Text('Modifier'),
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Congé enregistré avec succès'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to home
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

