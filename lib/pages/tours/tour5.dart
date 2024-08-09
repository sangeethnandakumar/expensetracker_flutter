import 'package:flutter/material.dart';
import 'base/base_tour_page.dart';

class Tour5 extends BaseTourPage {
  Tour5({required VoidCallback onNext})
      : super(
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/9490/9490701.png',
    title: 'Ad-Free Experience',
    description:
    'Enjoy a clean, distraction-free app. No ads, even in the free version!',
    features: [
      TourFeature(
        icon: Icons.block,
        title: 'No Advertisements',
        description: 'Focus on your finances without interruptions',
      ),
      TourFeature(
        icon: Icons.star,
        title: 'Premium Support',
        description: 'Get priority support from our expert team',
        isPremium: true,
      ),
    ],
    pageIndex: 5,
    totalPages: 5,
    onNext: onNext,
  );

  @override
  List<Color> getGradientColors() => [Color(0xFFC7F8CA), Colors.white];
}
