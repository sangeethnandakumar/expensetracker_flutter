import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../api.dart';
import '../models/CategoryModel.dart';
import 'category.dart';

class CategoryGrid extends StatefulWidget {
  final Function(String) onCategorySelected;
  final double itemHeight;
  final int noOfRows;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Function(List<CategoryModel>) setCategories;

  const CategoryGrid({
    Key? key,
    required this.onCategorySelected,
    required this.setCategories,
    required this.itemHeight,
    required this.noOfRows,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  }) : super(key: key);

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<CategoryModel> categories = [];
  bool isLoading = true;
  String? errorMessage;
  int? selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() {
    Api.get('/categories', (data) {
      setState(() {
        categories = (data as List).map((item) => CategoryModel.fromJson(item)).toList();
        widget.setCategories(categories);
        isLoading = false;
        if (categories.isNotEmpty) {
          widget.onCategorySelected(categories[0].id);
        }
      });
    }, (error) {
      setState(() {
        errorMessage = error;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    } else if (categories.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/ghost.json',
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 8),
                Text(
                  'Create categories to start with',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Add your logic to navigate to category creation page
              },
              child: Text('Add Category'),
            ),
          ],
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          double itemHeight = widget.itemHeight;

          // Calculate the total width needed for the items
          double totalWidth = constraints.maxWidth;
          double itemWidth = (totalWidth - (widget.crossAxisSpacing * (widget.noOfRows - 1))) / widget.noOfRows;

          if (widget.noOfRows == 1) {
            // Horizontal scrolling
            return GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: widget.crossAxisSpacing,
                mainAxisSpacing: widget.mainAxisSpacing,
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.onCategorySelected(categories[index].id);
                    });
                  },
                  onLongPress: () {
                    _showOptionsBottomSheet(categories[index].id);
                  },
                  child: AnimatedScale(
                    scale: selectedIndex == index ? 1.1 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Category(
                      category: categories[index],
                      isSelected: selectedIndex == index,
                    ).animate().fadeIn(duration: 500.ms),
                  ),
                );
              },
            );
          } else {
            // Vertical scrolling with wrapping
            return GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.noOfRows,
                crossAxisSpacing: widget.crossAxisSpacing,
                mainAxisSpacing: widget.mainAxisSpacing,
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.onCategorySelected(categories[index].id);
                    });
                  },
                  onLongPress: () {
                    _showOptionsBottomSheet(categories[index].id);
                  },
                  child: AnimatedScale(
                    scale: selectedIndex == index ? 1.1 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Category(
                      category: categories[index],
                      isSelected: selectedIndex == index,
                    ).animate().fadeIn(duration: 500.ms),
                  ),
                );
              },
            );
          }
        },
      );
    }
  }

  void _showOptionsBottomSheet(String categoryId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _showWarningDialog(categoryId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWarningDialog(String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?\nDeleting the category will remove all the expense tracks logged under it.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteCategory(categoryId);
                Navigator.pop(context); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(String categoryId) async {
    String endpoint = '/categories/$categoryId';

    try {
      await Api.delete(
        endpoint,
            (data) {
          setState(() {
            categories.removeWhere((category) => category.id == categoryId);
            widget.setCategories(categories); // Update categories in parent
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category deleted successfully.')));
        },
            (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }
}
