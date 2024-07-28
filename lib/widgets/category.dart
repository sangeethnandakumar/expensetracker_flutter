import 'dart:convert';
import 'package:flutter/material.dart';
import '../helpers/icon_mapping.dart';
import '../models/CategoryModel.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;

  Category({required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(int.parse(category.color.replaceFirst('#', '0xff'))),
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
                category.customImage!,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              IconMapping.getIcon(category.icon) ?? Icons.help,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(int.parse(category.color.replaceFirst('#', '0xff')))
                : Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            category.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
