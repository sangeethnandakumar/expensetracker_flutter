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
                child: Lottie.asset(
                  'assets/wind.json',
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Let's created a category to get started",
                style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              )
            ],
          )
        ],
      ),
    );
  }
}