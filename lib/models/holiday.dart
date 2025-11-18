/// Represents a holiday in the Moroccan calendar.
/// 
/// This model stores information about public holidays, religious holidays,
/// and other special days that affect vacation calculations.
/// 
/// Properties:
/// - [date]: The date of the holiday
/// - [name]: The name of the holiday in the primary language (French/English)
/// - [nameAr]: The name of the holiday in Arabic
/// - [type]: The type of holiday ('public', 'religious', etc.)
class Holiday {
  /// The date when the holiday occurs
  final DateTime date;
  
  /// The name of the holiday in the primary language (French/English)
  final String name;
  
  /// The name of the holiday in Arabic
  final String nameAr;
  
  /// The type of holiday (e.g., 'public', 'religious')
  final String type;

  /// Creates a new Holiday instance.
  /// 
  /// All parameters are required.
  Holiday({
    required this.date,
    required this.name,
    required this.nameAr,
    required this.type,
  });

  /// Creates a Holiday instance from JSON data.
  /// 
  /// Used when loading holidays from API responses or cached data.
  /// 
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "date": "2024-01-01T00:00:00.000Z",
  ///   "name": "New Year's Day",
  ///   "nameAr": "رأس السنة الميلادية",
  ///   "type": "public"
  /// }
  /// ```
  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']),
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      type: json['type'] ?? 'public',
    );
  }

  /// Converts the Holiday instance to JSON format.
  /// 
  /// Used when saving holidays to cache or sending data to APIs.
  /// 
  /// Returns a Map containing all holiday properties in JSON-compatible format.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'nameAr': nameAr,
      'type': type,
    };
  }
}

