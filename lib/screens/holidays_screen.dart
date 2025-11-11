import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/vacation_provider.dart';
import '../models/holiday.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jours Fériés au Maroc'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<VacationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.holidays.isEmpty) {
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

          // Group holidays by year
          final holidaysByYear = <int, List<Holiday>>{};
          for (var holiday in provider.holidays) {
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
                                    DateFormat('d').format(holiday.date),
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
                                    DateFormat('MMM', 'fr_FR').format(holiday.date),
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
                                  Text(
                                    holiday.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isPast ? Colors.grey[600] : null,
                                        ),
                                  ),
                                  if (holiday.nameAr.isNotEmpty)
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
                                        color: isPast ? Colors.grey[500] : Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat('EEEE', 'fr_FR').format(holiday.date),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: isPast ? Colors.grey[500] : null,
                                            ),
                                      ),
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
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
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
}

