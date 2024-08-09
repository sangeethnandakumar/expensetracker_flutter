import 'package:flutter/material.dart';
import '../Api.dart';
import '../bl/repos/categories_repo.dart';
import '../models/category_model.dart';
import '../widgets/categorygrid.dart';
import 'category_creation.dart';

class CategoryEditorPage extends StatefulWidget {
  @override
  _CategoryEditorPageState createState() => _CategoryEditorPageState();
}

class _CategoryEditorPageState extends State<CategoryEditorPage> {
  List<CategoryModel> categories = [];
  bool isLoading = true;
  final CategoryRepository _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    var allCatageories = await _categoryRepository.getAll();

    setState(() {
      categories = allCatageories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Editor'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CategoryGrid(
        categories: categories,
        itemHeight: 100,
        noOfRows: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        onCategorySelected: (categoryId) {
          print("Selected category: $categoryId");
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryCreationPage(),
            ),
          );

          if (result == true) {
            fetchCategories();
          }
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