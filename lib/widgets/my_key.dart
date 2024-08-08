import 'package:flutter/material.dart';

class MyKey extends StatelessWidget {
  final String keyName;
  final Function(String) onKeyTap;
  final Color color;

  MyKey({required this.keyName, required this.onKeyTap, this.color = Colors.green});

  @override
  Widget build(BuildContext context) {
    // Generate shades for the gradient
    final Color darkerColor = color.withOpacity(0.7); // Darker shade for gradient
    final Color lighterColor = color.withOpacity(0.3); // Lighter shade for gradient

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            onKeyTap(keyName);
          },
          child: Container(
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lighterColor, // Start color
                  darkerColor, // End color
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                keyName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black, // Change text color for better contrast
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
