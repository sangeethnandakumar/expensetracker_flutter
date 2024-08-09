import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/category_model.dart';
import '../models/record_model.dart';
import 'record_card.dart';

class RecordsList extends StatelessWidget {
  final List<RecordModel> records;
  final Function(String) onLongPress;
  final CategoryModel? Function(String) getCategory;

  // Icon mapping
  static const Map<String, IconData> iconMapping = {
    'food': Icons.restaurant,
    'repair': Icons.build,
    'shopping': Icons.shopping_cart,
    'fuel': Icons.oil_barrel,
    // Add more icon mappings as needed
  };

  const RecordsList({
    Key? key,
    required this.records,
    required this.onLongPress,
    required this.getCategory,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    return iconMapping[category] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    // Group records by category
    Map<String, List<RecordModel>> groupedRecords = {};
    for (var record in records) {
      CategoryModel? category = getCategory(record.category);
      String categoryTitle = category?.title ?? 'Unknown Category';
      if (!groupedRecords.containsKey(categoryTitle)) {
        groupedRecords[categoryTitle] = [];
      }
      groupedRecords[categoryTitle]!.add(record);
    }

    return ListView.builder(
      itemCount: groupedRecords.length,
      itemBuilder: (context, index) {
        String categoryTitle = groupedRecords.keys.elementAt(index);
        List<RecordModel> categoryRecords = groupedRecords[categoryTitle]!;
        CategoryModel? category = getCategory(categoryRecords.first.category);

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            leading: Icon(_getCategoryIcon(category?.icon ?? '')),
            title: Text(
              categoryTitle,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
            children: categoryRecords.map((record) {
              int recordIndex = categoryRecords.indexOf(record);
              return Animate(
                effects: [FadeEffect(duration: 200.ms, delay: (recordIndex * 25).ms)],
                child: RecordCard(
                  record: record,
                  longPressCallback: () => onLongPress(record.id),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
