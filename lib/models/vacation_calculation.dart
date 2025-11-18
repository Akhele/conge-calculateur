/// Represents the result of a vacation calculation.
/// 
/// This model contains all the information about a calculated vacation period,
/// including start date, return date, and breakdown of days (working days,
/// weekends, holidays).
/// 
/// Properties:
/// - [startDate]: The first day of vacation
/// - [requestedDays]: Number of working days requested
/// - [returnDate]: The first working day after vacation ends
/// - [totalCalendarDays]: Total calendar days from start to return date
/// - [weekendDays]: Number of weekend days included in the vacation period
/// - [holidayDays]: Number of holiday days (on weekdays) included in the period
/// - [holidays]: List of holiday dates that fall on weekdays (counted)
/// - [weekendHolidays]: List of holiday dates that fall on weekends (not counted)
class VacationCalculation {
  /// The first day of the vacation period
  final DateTime startDate;
  
  /// The number of working days requested for vacation
  final int requestedDays;
  
  /// The first working day after the vacation ends (return to work date)
  final DateTime returnDate;
  
  /// Total calendar days from start date to return date (inclusive)
  final int totalCalendarDays;
  
  /// Number of weekend days (Saturday/Sunday) in the vacation period
  final int weekendDays;
  
  /// Number of holiday days that fall on weekdays (these are counted as vacation days)
  final int holidayDays;
  
  /// List of holiday dates that occur on weekdays during the vacation period
  final List<DateTime> holidays;
  
  /// List of holiday dates that fall on weekends (not counted toward vacation days)
  final List<DateTime> weekendHolidays;

  /// Creates a new VacationCalculation instance.
  /// 
  /// [weekendHolidays] is optional and defaults to an empty list.
  VacationCalculation({
    required this.startDate,
    required this.requestedDays,
    required this.returnDate,
    required this.totalCalendarDays,
    required this.weekendDays,
    required this.holidayDays,
    required this.holidays,
    this.weekendHolidays = const [],
  });

  /// Converts the VacationCalculation to JSON format.
  /// 
  /// Used for saving vacation history to persistent storage.
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'requestedDays': requestedDays,
      'returnDate': returnDate.toIso8601String(),
      'totalCalendarDays': totalCalendarDays,
      'weekendDays': weekendDays,
      'holidayDays': holidayDays,
      'holidays': holidays.map((d) => d.toIso8601String()).toList(),
      'weekendHolidays': weekendHolidays.map((d) => d.toIso8601String()).toList(),
    };
  }

  /// Creates a VacationCalculation instance from JSON data.
  /// 
  /// Used when loading vacation history from persistent storage.
  /// 
  /// Handles backward compatibility by making [weekendHolidays] optional
  /// (for calculations saved before this field was added).
  factory VacationCalculation.fromJson(Map<String, dynamic> json) {
    return VacationCalculation(
      startDate: DateTime.parse(json['startDate']),
      requestedDays: json['requestedDays'],
      returnDate: DateTime.parse(json['returnDate']),
      totalCalendarDays: json['totalCalendarDays'],
      weekendDays: json['weekendDays'],
      holidayDays: json['holidayDays'],
      holidays: (json['holidays'] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
      weekendHolidays: json['weekendHolidays'] != null
          ? (json['weekendHolidays'] as List)
              .map((d) => DateTime.parse(d))
              .toList()
          : [],
    );
  }
}

