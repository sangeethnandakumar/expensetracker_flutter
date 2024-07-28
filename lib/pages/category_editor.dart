import 'package:flutter/material.dart';
import '../widgets/categorygrid.dart';
import 'category_creation.dart'; // Import the new page

class CategoryEditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Editor'),
      ),
      body: CategoryGrid(
        onCategorySelected: (categoryId) {
          // Handle category selection if needed
          print("Selected category: $categoryId");
        },
        setCategories: (categories) {
          // You can add any additional logic to manage categories if necessary
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the category creation page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryCreationPage(),
            ),
          );
        },
        label: Text('Add New Category'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
