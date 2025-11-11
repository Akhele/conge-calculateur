import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Congés'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<VacationProvider>(
        builder: (context, provider, child) {
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
                    'Aucun congé enregistré',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vos congés confirmés apparaîtront ici',
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
                  onTap: () => _showDetailsDialog(context, calculation),
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
                                    '${calculation.requestedDays} jours ouvrables',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    isOngoing
                                        ? 'En cours'
                                        : isPast
                                            ? 'Terminé'
                                            : 'À venir',
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
                                'Début',
                                calculation.startDate,
                                Icons.play_arrow,
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
                                'Retour',
                                calculation.returnDate,
                                Icons.work,
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
                                'Total',
                              ),
                              _buildStatChip(
                                context,
                                '${calculation.weekendDays}',
                                'Week-ends',
                              ),
                              _buildStatChip(
                                context,
                                '${calculation.holidayDays}',
                                'Fériés',
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

  Widget _buildDateInfo(BuildContext context, String label, DateTime date, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          DateFormat('d MMM', 'fr_FR').format(date),
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

  void _showDetailsDialog(BuildContext context, calculation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails du congé'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date de début', DateFormat('d MMMM yyyy', 'fr_FR').format(calculation.startDate)),
            _buildDetailRow('Date de retour', DateFormat('d MMMM yyyy', 'fr_FR').format(calculation.returnDate)),
            _buildDetailRow('Jours ouvrables', '${calculation.requestedDays} jours'),
            _buildDetailRow('Durée totale', '${calculation.totalCalendarDays} jours'),
            _buildDetailRow('Week-ends', '${calculation.weekendDays} jours'),
            _buildDetailRow('Jours fériés', '${calculation.holidayDays} jours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
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
        title: const Text('Supprimer le congé'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce congé de l\'historique ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              provider.deleteHistoryItem(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Congé supprimé')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

