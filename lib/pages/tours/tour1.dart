import 'package:flutter/material.dart';
import 'base/base_tour_page.dart';

class Tour1 extends BaseTourPage {
  Tour1({required VoidCallback onNext})
      : super(
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/10692/10692995.png',
    title: 'Track Your Expenses and Income',
    description:
    'Take control of your finances with our powerful expense tracking features.',
    features: [
      TourFeature(
        icon: Icons.add,
        title: 'Easy Tracking',
        description: 'Log expenses and income in seconds',
      ),
      TourFeature(
        icon: Icons.category,
        title: 'Smart Categories',
        description: 'Automatically categorize your transactions',
      ),
    ],
    pageIndex: 1,
    totalPages: 5,
    onNext: onNext,
  );

  @override
  List<Color> getGradientColors() => [Color(0xFFFFF7A2), Colors.white];
}