import 'package:flutter/material.dart';
import 'base/base_tour_page.dart';

class Tour2 extends BaseTourPage {
  Tour2({required VoidCallback onNext})
      : super(
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/1069/1069839.png',
    title: 'Sync Across All Your Devices',
    description:
    'Access your financial data anywhere, anytime. Seamlessly sync across all your devices.',
    features: [
      TourFeature(
        icon: Icons.sync,
        title: 'Real-time Sync',
        description: 'Your data is always up-to-date on all devices',
        isPremium: true,
      ),
      TourFeature(
        icon: Icons.cloud,
        title: 'Cloud Backup',
        description: 'Never lose your financial data again',
        isPremium: true,
      ),
    ],
    pageIndex: 2,
    totalPages: 5,
    onNext: onNext,
  );

  @override
  List<Color> getGradientColors() => [Color(0xFFF6A2FF), Colors.white];
}