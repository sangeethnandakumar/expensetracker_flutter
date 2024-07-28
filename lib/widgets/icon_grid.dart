import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/icon_mapping.dart';

class IconGrid extends StatelessWidget {
  final String? selectedIconName;
  final Function(String) onIconSelected;

  const IconGrid({
    Key? key,
    required this.selectedIconName,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> sampleIcons = IconMapping.iconMapping.keys.toList();

    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: sampleIcons.length,
            itemBuilder: (context, index) {
              String iconName = sampleIcons[index];
              IconData? icon = IconMapping.getIcon(iconName);
              return GestureDetector(
                onTap: () => onIconSelected(iconName),
                child: Icon(
                  icon,
                  size: 30,
                  color: iconName == selectedIconName ? Colors.blue : Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}