import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CurrencyEditor extends StatelessWidget {
  final String money;
  final double fontSize; // New parameter for font size
  final Color textColor; // New parameter for text color

  CurrencyEditor({
    required this.money,
    this.fontSize = 100, // Default value
    this.textColor = Colors.black, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹',
              style: TextStyle(
                color: Colors.grey,
                fontSize: fontSize * 0.8, // Smaller size for ₹
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              money,
              style: TextStyle(
                color: textColor, // Use the passed text color
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
