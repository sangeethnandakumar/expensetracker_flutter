import 'package:flutter/material.dart';
import 'base/base_tour_page.dart';

class Tour4 extends BaseTourPage {
  Tour4({required VoidCallback onNext})
      : super(
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2302/2302704.png',
    title: 'Unlock Premium Features',
    description:
    'Elevate your financial management with our premium features. Invest in your financial future today!',
    features: [
      TourFeature(
        icon: Icons.analytics,
        title: 'Advanced Analytics',
        description: 'Gain deep insights into your spending habits',
        isPremium: true,
      ),
      TourFeature(
        icon: Icons.savings,
        title: 'Smart Budgeting',
        description: 'Set and track budgets with AI recommendations',
        isPremium: true,
      ),
    ],
    pageIndex: 4,
    totalPages: 5,
    onNext: onNext,
  );

  @override
  List<Color> getGradientColors() => [Color(0xFFC7F8CA), Colors.white];
}