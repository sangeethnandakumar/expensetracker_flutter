import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/record_model.dart';

class RecordCard extends StatelessWidget {
  final RecordModel record;
  final VoidCallback? longPressCallback;

  const RecordCard({Key? key, required this.record, this.longPressCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the record is fresh
    bool isFresh = timeago.format(record.date) == "a moment ago";

    return GestureDetector(
      onLongPress: longPressCallback,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2, // Reduced elevation
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isFresh
                  ? [Colors.white, record.isIncome ? Colors.green.shade300 : Colors.deepOrange.shade400] // Higher saturation for fresh items
                  : [Colors.white, record.isIncome ? Colors.green.shade300 : Colors.orange.shade100], // Normal saturation for older items
            ),
          ),
          child: ListTile(
            leading: Icon(
              record.isIncome ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
              size: 40,
              color: record.isIncome ? Colors.green :  Colors.redAccent.shade100,
            ),
            title: Text(
              '₹ ${record.amt.toString()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (record.notes.isNotEmpty)
                  Text(record.notes, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    timeago.format(record.date),
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}