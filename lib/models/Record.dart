// lib/models/record.dart
class Record {
  final String id;
  final DateTime date;
  final double exp;
  final String notes;
  final String category;

  Record({
    required this.id,
    required this.date,
    required this.exp,
    required this.notes,
    required this.category,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      date: DateTime.parse(json['date']),
      exp: json['exp'].toDouble(),
      notes: json['notes'],
      category: json['category'],
    );
  }
}
