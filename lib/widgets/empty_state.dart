import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Apply the animation to the Lottie widget
                Container(
                  child: Lottie.asset(
                    'assets/empty.json',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ).animate().fadeIn(duration: 500.ms), // Fade-in animation here
                SizedBox(height: 16),
                Text(
                  'No Expense Recorded For The Selected Date',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
