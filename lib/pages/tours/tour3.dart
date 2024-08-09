import 'package:flutter/material.dart';
import 'base/base_tour_page.dart';

class Tour3 extends BaseTourPage {
  Tour3({required VoidCallback onNext})
      : super(
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/5031/5031768.png',
    title: 'Smart Bank SMS Detection',
    description:
    'Let AI do the work for you. Automatically extract and log transactions from your bank SMS.',
    features: [
      TourFeature(
        icon: Icons.sms,
        title: 'AI-Powered SMS Parsing',
        description: 'Automatically detect and log transactions from SMS',
        isPremium: true,
      ),
      TourFeature(
        icon: Icons.security,
        title: 'Bank-Level Security',
        description: 'Your data is encrypted and secure',
      ),
    ],
    pageIndex: 3,
    totalPages: 5,
    onNext: onNext,
  );

  @override
  List<Color> getGradientColors() => [Color(0xFFB9F1F3), Colors.white];
}