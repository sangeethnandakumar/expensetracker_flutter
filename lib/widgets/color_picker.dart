import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;
  final List<Color> colors;

  ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.colors,
  }) : super(key: key);

  late final List<Color> _expandedColors = _generateExpandedColors();

  List<Color> _generateExpandedColors() {
    List<Color> expandedColors = List.from(colors);

    // Generate 5 colors from white to cream
    for (int i = 0; i < 5; i++) {
      double factor = i / 4;
      expandedColors.add(Color.lerp(Colors.white, Color(0xFFFFFDD0), factor)!);
    }

    // Generate 5 colors from light chocolate to black
    for (int i = 0; i < 5; i++) {
      double factor = i / 4;
      expandedColors.add(Color.lerp(Color(0xFFD2691E), Colors.black, factor)!);
    }

    return expandedColors;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _expandedColors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onColorSelected(_expandedColors[index]);
          },
          child: SizedBox(
            width: 30,
            height: 30,
            child: CustomPaint(
              painter: DottedBorderPainter(
                color: Colors.grey,
                strokeWidth: 1,
                gap: 3,
              ),
              child: Padding(
                padding: EdgeInsets.all(3), // Add some padding for the border
                child: Container(
                  decoration: BoxDecoration(
                    color: _expandedColors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _expandedColors[index] == selectedColor ? Colors.white70 : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ).animate().scale(),
          ),
        );
      },
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    ));

    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final Path extractPath = pathMetric.extractPath(0, pathMetric.length);
      canvas.drawPath(
        dashPath(extractPath, dashArray: CircularIntervalList<double>([gap, gap])),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  Path dashPath(Path path, {required CircularIntervalList<double> dashArray}) {
    final Path dashPath = Path();
    final PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric metric in pathMetrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = dashArray.next;
        if (draw) {
          dashPath.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
      }
    }
    return dashPath;
  }
}

class CircularIntervalList<T> {
  final List<T> _items;
  int _index = 0;

  CircularIntervalList(this._items);

  T get next {
    if (_index >= _items.length) {
      _index = 0;
    }
    return _items[_index++];
  }
}