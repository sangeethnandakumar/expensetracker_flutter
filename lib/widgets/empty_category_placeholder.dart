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
              Text(
                "Create A New Category To Get Started",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Container(
                child: Lottie.asset(
                  'assets/wind.json',
                  width: 100,
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