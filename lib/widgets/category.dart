import 'dart:convert';
import 'package:flutter/material.dart';
import '../helpers/icon_mapping.dart';
import '../models/category_model.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;

  Category({required this.category, required this.isSelected});

  bool _isVeryLightColor(Color color) {
    // Adjust the threshold to be less sensitive to light colors
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.75; // Adjusted threshold for very light colors
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(int.parse(category.color.replaceFirst('#', '0xff')));
    bool isVeryLightBgColor = _isVeryLightColor(bgColor);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: category.customImage != null
                ? ClipOval(
              child: category.customImage!.startsWith('data:image')
                  ? Image.memory(
                Base64Decoder().convert(category.customImage!.split(',')[1]),
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              )
                  : Image.network(
                'https://expensetracker.twileloop.com/images/' + category.customImage!,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              IconMapping.getIcon(category.icon) ?? Icons.help,
              size: 28,
              color: isVeryLightBgColor ? Colors.black : Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: isSelected
                ? bgColor
                : Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            category.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? (isVeryLightBgColor ? Colors.black : Colors.white)
                  : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
