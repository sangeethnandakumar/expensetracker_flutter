// lib/models/record.dart
class RecordModel {
  final String id;
  final String date;
  final double amt;
  final String notes;
  final String category;
  final bool isIncome;

  RecordModel({
    required this.id,
    required this.date,
    required this.amt,
    required this.notes,
    required this.category,
    required this.isIncome,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      date: json['date'],
      amt: json['exp'].toDouble(),
      notes: json['notes'],
      category: json['category'],
      isIncome: json['isIncome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'exp': amt,
      'notes': notes,
      'category': category,
      'isIncome': isIncome,
    };
  }
}
