import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const CategoryCircle({Key? key, required this.backgroundColor, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(child: child),
    );
  }
}
