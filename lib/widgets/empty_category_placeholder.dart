import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyCategoryPlaceholder extends StatelessWidget {
  final VoidCallback onAddCategory;

  const EmptyCategoryPlaceholder({
    Key? key,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100, // Pale blue color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Text(
                  "Create A New Category To Get Started",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 1), // Add some spacing between text and animation
              Container(
                child: Lottie.asset(
                  'assets/wind.json',
                  width: 80,
                  fit: BoxFit.contain,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
