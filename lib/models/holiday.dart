class Holiday {
  final DateTime date;
  final String name;
  final String nameAr;
  final String type;

  Holiday({
    required this.date,
    required this.name,
    required this.nameAr,
    required this.type,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']),
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      type: json['type'] ?? 'public',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'nameAr': nameAr,
      'type': type,
    };
  }
}

