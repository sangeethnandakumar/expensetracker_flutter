import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../api.dart';
import '../models/CategoryModel.dart';
import 'category.dart';

class CategoryGrid extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function(String) onCategorySelected;
  final double itemHeight;
  final int noOfRows;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const CategoryGrid({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
    required this.itemHeight,
    required this.noOfRows,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  }) : super(key: key);

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  int? selectedIndex = 0;

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
                  Navigator.pop(context);
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
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteCategory(categoryId);
                Navigator.pop(context);
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
            widget.categories.removeWhere((category) => category.id == categoryId);
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

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
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
          double totalWidth = constraints.maxWidth;
          double itemWidth = (totalWidth - (widget.crossAxisSpacing * (widget.noOfRows - 1))) / widget.noOfRows;

          if (widget.noOfRows == 1) {
            return SizedBox(
              height: itemHeight,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: widget.crossAxisSpacing,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(index, itemWidth, itemHeight);
                },
              ),
            );
          } else {
            return SizedBox(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.noOfRows,
                  crossAxisSpacing: widget.crossAxisSpacing,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(index, itemWidth, itemHeight);
                },
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildCategoryItem(int index, double itemWidth, double itemHeight) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.onCategorySelected(widget.categories[index].id);
        });
      },
      onLongPress: () {
        _showOptionsBottomSheet(widget.categories[index].id);
      },
      child: AnimatedScale(
        scale: selectedIndex == index ? 1.1 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Category(
          category: widget.categories[index],
          isSelected: selectedIndex == index,
        ).animate().fadeIn(duration: 500.ms),
      ),
    );
  }
}