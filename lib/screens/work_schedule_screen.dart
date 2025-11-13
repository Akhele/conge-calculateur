import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TimingSystem {
  twelveTwentyFour,
  twelveTwentyFourTwelveFortyEight,
}

enum WorkType {
  jour,
  nuit,
  journeeCouverte,
  reposCompensateur,
}

enum DayStatus {
  jour,
  nuit,
  journeeCouverte,
  reposCompensateur,
}

class WorkScheduleScreen extends StatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  State<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {
  TimingSystem _selectedTiming = TimingSystem.twelveTwentyFour;
  WorkType _currentWorkType = WorkType.jour;
  late DateTime _todayDate;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    // Set today's date to today at midnight
    final now = DateTime.now();
    _todayDate = DateTime(now.year, now.month, now.day);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadStartTime();
  }

  Future<void> _loadStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('workStartHour') ?? 9;
    final minute = prefs.getInt('workStartMinute') ?? 0;
    setState(() {
      _startTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveStartTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workStartHour', time.hour);
    await prefs.setInt('workStartMinute', time.minute);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}h${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _getEndTime() {
    // End time is start time + 12 hours
    final totalMinutes = _startTime.hour * 60 + _startTime.minute + (12 * 60);
    final endHour = (totalMinutes ~/ 60) % 24;
    final endMinute = totalMinutes % 60;
    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  String _getJourTimeRange() {
    return '${_formatTime(_startTime)} -> ${_formatTime(_getEndTime())}';
  }

  String _getNuitTimeRange() {
    return '${_formatTime(_getEndTime())} -> ${_formatTime(_startTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculateur de Planning de Travail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      Icons.schedule,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Système de Planning de Travail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sélectionnez votre système de timing et votre type de travail actuel',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timing system selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Système de Timing',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<TimingSystem>(
                      title: const Text('12/24'),
                      subtitle: const Text('Travail 12h, repos 24h'),
                      value: TimingSystem.twelveTwentyFour,
                      groupValue: _selectedTiming,
                      onChanged: (value) {
                        setState(() {
                          _selectedTiming = value!;
                          // Reset work type if it's not available in the new system
                          if (_selectedTiming == TimingSystem.twelveTwentyFour &&
                              _currentWorkType == WorkType.reposCompensateur) {
                            _currentWorkType = WorkType.journeeCouverte;
                          }
                        });
                      },
                    ),
                    RadioListTile<TimingSystem>(
                      title: const Text('12/24, 12/48'),
                      subtitle: const Text('Jour: 12h repos 24h, Nuit: 12h repos 48h'),
                      value: TimingSystem.twelveTwentyFourTwelveFortyEight,
                      groupValue: _selectedTiming,
                      onChanged: (value) {
                        setState(() {
                          _selectedTiming = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Start time selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heure de Début',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _selectStartTime(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heure de début du travail',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    _formatTime(_startTime),
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

            // Current work type selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type de Travail Aujourd\'hui',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<WorkType>(
                      title: const Text('Jour'),
                      subtitle: Text(_getJourTimeRange()),
                      value: WorkType.jour,
                      groupValue: _currentWorkType,
                      onChanged: (value) {
                        setState(() {
                          _currentWorkType = value!;
                        });
                      },
                    ),
                    RadioListTile<WorkType>(
                      title: const Text('Nuit'),
                      subtitle: Text(_getNuitTimeRange()),
                      value: WorkType.nuit,
                      groupValue: _currentWorkType,
                      onChanged: (value) {
                        setState(() {
                          _currentWorkType = value!;
                        });
                      },
                    ),
                    RadioListTile<WorkType>(
                      title: const Text('Journée Couverte'),
                      subtitle: const Text('Repos'),
                      value: WorkType.journeeCouverte,
                      groupValue: _currentWorkType,
                      onChanged: (value) {
                        setState(() {
                          _currentWorkType = value!;
                        });
                      },
                    ),
                    if (_selectedTiming == TimingSystem.twelveTwentyFourTwelveFortyEight)
                      RadioListTile<WorkType>(
                        title: const Text('Repos Compensateur'),
                        subtitle: const Text('Repos'),
                        value: WorkType.reposCompensateur,
                        groupValue: _currentWorkType,
                        onChanged: (value) {
                          setState(() {
                            _currentWorkType = value!;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected date picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date à Vérifier',
                      style: TextStyle(
                        fontSize: 16,
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
                              Icons.event,
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
            const SizedBox(height: 24),

            // Result card
            Card(
              elevation: 4,
              child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Résultat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResultDisplay(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultDisplay() {
    final dayStatus = _calculateDayStatus(_selectedDate);
    
    String statusText;
    IconData statusIcon;
    Color statusColor;
    String subtitle;

    switch (dayStatus) {
      case DayStatus.jour:
        statusText = 'Jour';
        subtitle = _getJourTimeRange();
        statusIcon = Icons.wb_sunny;
        statusColor = Colors.orange;
        break;
      case DayStatus.nuit:
        statusText = 'Nuit';
        subtitle = '${_getNuitTimeRange()}\n(Journée couverte)';
        statusIcon = Icons.nightlight_round;
        statusColor = Colors.indigo;
        break;
      case DayStatus.journeeCouverte:
        statusText = 'Journée Couverte';
        subtitle = 'Repos';
        statusIcon = Icons.bedtime;
        statusColor = Colors.green;
        break;
      case DayStatus.reposCompensateur:
        statusText = 'Repos Compensateur';
        subtitle = 'Repos';
        statusIcon = Icons.hotel;
        statusColor = Colors.teal;
        break;
    }

    return Column(
      children: [
        Icon(
          statusIcon,
          size: 64,
          color: statusColor,
        ),
        const SizedBox(height: 16),
        Text(
          statusText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  DayStatus _calculateDayStatus(DateTime targetDate) {
    // Normalize dates to start of day
    final today = DateTime(_todayDate.year, _todayDate.month, _todayDate.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    
    // Calculate difference in days
    final daysDifference = target.difference(today).inDays;

    if (daysDifference == 0) {
      // Today - return current work type
      switch (_currentWorkType) {
        case WorkType.jour:
          return DayStatus.jour;
        case WorkType.nuit:
          return DayStatus.nuit;
        case WorkType.journeeCouverte:
          return DayStatus.journeeCouverte;
        case WorkType.reposCompensateur:
          return DayStatus.reposCompensateur;
      }
    }
    
    // Calculate based on cycle pattern
    return _calculateCycleStatus(daysDifference);
  }

  DayStatus _calculateCycleStatus(int daysFromToday) {
    if (_selectedTiming == TimingSystem.twelveTwentyFour) {
      // Pattern for 12/24: Cycle of 3 days
      // Pattern: Jour -> Nuit/Journée couverte -> Journée couverte -> Jour -> repeat
      
      int cyclePosition = daysFromToday % 3;
      if (cyclePosition < 0) {
        cyclePosition = (cyclePosition % 3 + 3) % 3; // Handle negative modulo
      }
      
      // Determine starting position based on current work type
      int startOffset = 0;
      switch (_currentWorkType) {
        case WorkType.jour:
          startOffset = 0; // Jour is position 0
          break;
        case WorkType.nuit:
          startOffset = 1; // Nuit is position 1
          break;
        case WorkType.journeeCouverte:
          startOffset = 2; // Journée couverte is position 2
          break;
        case WorkType.reposCompensateur:
          // Not available in 12/24, fallback to journeeCouverte
          startOffset = 2;
          break;
      }
      
      int position = (cyclePosition + startOffset) % 3;
      switch (position) {
        case 0:
          return DayStatus.jour;
        case 1:
          return DayStatus.nuit; // This day is also "Journée couverte"
        case 2:
          return DayStatus.journeeCouverte;
        default:
          return DayStatus.jour;
      }
    } else {
      // Pattern for 12/24, 12/48: Cycle of 4 days
      // Pattern: Jour -> Nuit/Journée couverte -> Journée couverte -> Repos compensateur -> Jour -> repeat
      
      int cyclePosition = daysFromToday % 4;
      if (cyclePosition < 0) {
        cyclePosition = (cyclePosition % 4 + 4) % 4; // Handle negative modulo
      }
      
      // Determine starting position based on current work type
      int startOffset = 0;
      switch (_currentWorkType) {
        case WorkType.jour:
          startOffset = 0; // Jour is position 0
          break;
        case WorkType.nuit:
          startOffset = 1; // Nuit is position 1
          break;
        case WorkType.journeeCouverte:
          startOffset = 2; // Journée couverte is position 2
          break;
        case WorkType.reposCompensateur:
          startOffset = 3; // Repos compensateur is position 3
          break;
      }
      
      int position = (cyclePosition + startOffset) % 4;
      switch (position) {
        case 0:
          return DayStatus.jour;
        case 1:
          return DayStatus.nuit; // This day is also "Journée couverte"
        case 2:
          return DayStatus.journeeCouverte;
        case 3:
          return DayStatus.reposCompensateur;
        default:
          return DayStatus.jour;
      }
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
      await _saveStartTime(picked);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

