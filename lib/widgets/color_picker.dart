import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;
  final List<Color> colors;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,  // Adjust the number of columns to spread the color circles
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onColorSelected(colors[index]);
          },
          child: SizedBox(
            width: 24,  // Set the size of the color circles
            height: 24, // Set the size of the color circles
            child: Container(
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors[index] == selectedColor ? Colors.white70 : Colors.transparent,
                  width: 3,
                ),
              ),
            ).animate().scale(),
          ),
        );
      },
    );
  }
}
