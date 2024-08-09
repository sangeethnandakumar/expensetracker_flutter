// tour_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../tour1.dart';
import '../tour2.dart';
import '../tour3.dart';
import '../tour4.dart';
import '../tour5.dart';

class TourManager extends StatefulWidget {
  final VoidCallback onTourComplete;

  const TourManager({Key? key, required this.onTourComplete}) : super(key: key);

  @override
  _TourManagerState createState() => _TourManagerState();
}

class _TourManagerState extends State<TourManager> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onTourComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: [
        Tour1(onNext: _nextPage),
        Tour2(onNext: _nextPage),
        Tour3(onNext: _nextPage),
        Tour4(onNext: _nextPage),
        Tour5(onNext: _nextPage),
      ],
    ).animate().fadeIn();
  }
}