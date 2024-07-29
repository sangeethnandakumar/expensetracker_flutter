import 'package:flutter/material.dart';
import '../Api.dart';
import '../models/CategoryModel.dart';
import '../widgets/categorygrid.dart';
import 'category_creation.dart';

class CategoryEditorPage extends StatefulWidget {
  @override
  _CategoryEditorPageState createState() => _CategoryEditorPageState();
}

class _CategoryEditorPageState extends State<CategoryEditorPage> {
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() {
    setState(() {
      isLoading = true;
    });
    Api.get('/categories', (data) {
      setState(() {
        categories = (data as List).map((item) => CategoryModel.fromJson(item)).toList();
        isLoading = false;
      });
    }, (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print("Error fetching categories: $error");
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