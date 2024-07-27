// category_editor.dart
import 'package:flutter/material.dart';
import '../models/CategoryModel.dart';
import '../widgets/category.dart';

class CategoryEditorPage extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryEditorPage({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 categories per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Category(
              category: categories[index],
              isSelected: false,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle adding new category
          print("Add new category");
        },
        label: Text('Add Category'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
