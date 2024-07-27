import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayBar extends StatelessWidget {
  final DateTime date;
  final bool isSelected;

  DayBar({required this.date, this.isSelected = false});

  bool isToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime date2 = DateTime(date.year, date.month, date.day);
    return today.isAtSameMomentAs(date2);
  }

  String getShortDay() {
    return DateFormat.E().format(date).toUpperCase();
  }

  String getShortMonth() {
    return DateFormat.MMM().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [Color(0xFF1E88E5), Color(0xFF64B5F6)]  // More saturated blue gradient
                : [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],  // Softer but still visible gradient
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 30,
                color: isSelected ? Colors.white : Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              getShortDay(),
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF1565C0),
              ),
            ),
            Text(
              getShortMonth(),
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF1565C0),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}