// base_tour_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

abstract class BaseTourPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final List<TourFeature> features;
  final int pageIndex;
  final int totalPages;
  final VoidCallback onNext;

  const BaseTourPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.features,
    required this.pageIndex,
    required this.totalPages,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: getGradientColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          imageUrl,
                          height: 150,
                        ).animate().fadeIn().scale(),
                        SizedBox(height: 24.0),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn().slideY(begin: 0.5, end: 0),
                        SizedBox(height: 16.0),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn().slideY(begin: 0.5, end: 0),
                        SizedBox(height: 32.0),
                        ...features.map((feature) => FeatureItem(feature: feature)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                NextButton(
                  onNext: onNext,
                  isLastPage: pageIndex == totalPages,
                ),
                SizedBox(height: 16.0),
                PageIndicator(currentPage: pageIndex, totalPages: totalPages),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> getGradientColors();
}

class TourFeature {
  final IconData icon;
  final String title;
  final String description;
  final bool isPremium;

  TourFeature({
    required this.icon,
    required this.title,
    required this.description,
    this.isPremium = false,
  });
}

class FeatureItem extends StatelessWidget {
  final TourFeature feature;

  const FeatureItem({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(
            feature.icon,
            color: Colors.blue[900],
            size: 32.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14.0,
                  ),
                ),
                if (feature.isPremium)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Premium Feature',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onNext;
  final bool isLastPage;

  const NextButton({Key? key, required this.onNext, required this.isLastPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onNext,
      icon: Icon(isLastPage ? Icons.check : Icons.arrow_forward_rounded),
      label: Text(
        isLastPage ? 'Get Started' : 'Next',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    ).animate().fadeIn().scale();
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({Key? key, required this.currentPage, required this.totalPages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) => Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage - 1 ? Colors.blue[900] : Colors.grey[400],
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}