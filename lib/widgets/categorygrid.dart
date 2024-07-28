import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api.dart';
import '../models/CategoryModel.dart';
import 'category.dart';

class CategoryGrid extends StatefulWidget {
  final Function(String) onCategorySelected;
  final Function(List<CategoryModel>) setCategories;

  const CategoryGrid({Key? key, required this.onCategorySelected, required this.setCategories}) : super(key: key);

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
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          double itemWidth = (constraints.maxWidth - 40) / 4;
          double itemHeight = 80;

          return SizedBox(
            height: itemHeight,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
            ),
          );
        },
      );
    }
  }
}
