class VacationCalculation {
  final DateTime startDate;
  final int requestedDays;
  final DateTime returnDate;
  final int totalCalendarDays;
  final int weekendDays;
  final int holidayDays;
  final List<DateTime> holidays;
  final List<DateTime> weekendHolidays; // Holidays that fall on weekends (not counted)

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

