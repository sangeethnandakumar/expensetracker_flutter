import 'package:flutter/material.dart';
import '../Api.dart';
import '../models/CategoryModel.dart';
import '../widgets/category.dart';
import '../widgets/icon_grid.dart';
import '../widgets/notes_input.dart';
import '../widgets/color_picker.dart';
import '../widgets/circular_image_cropper.dart';

class CategoryCreationPage extends StatefulWidget {
  const CategoryCreationPage({Key? key}) : super(key: key);

  @override
  _CategoryCreationPageState createState() => _CategoryCreationPageState();
}

class _CategoryCreationPageState extends State<CategoryCreationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedIconName;
  String? selectedImage;
  Color selectedColor = Colors.blue; // Default color
  String title = 'Preview';
  List<Color> currentColors = List.generate(20, (index) {
    double hue = (360 / 20) * index; // 20 colors with evenly spaced hues
    return HSVColor.fromAHSV(1.0, hue, 0.8, 0.8).toColor();
  });
  String? base64Image; // To store base64 representation of the cropped image

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          selectedIconName = 'food'; // Reset to first icon
          selectedImage = null; // Clear selectedImage
          base64Image = null; // Clear base64 image
          selectedColor = currentColors.first; // Reset to first color
          currentColors = List.generate(20, (index) { // Reset to static colors
            double hue = (360 / 20) * index; // 20 colors with evenly spaced hues
            return HSVColor.fromAHSV(1.0, hue, 0.8, 0.8).toColor();
          });
        });
      }
    });
    // Initialize the first icon and color on the first load
    selectedIconName = 'food';
    selectedColor = currentColors.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildPreview() {
    CategoryModel previewCategory = CategoryModel(
      id: '',
      title: title,
      icon: selectedIconName ?? 'help',
      color: '#${selectedColor.value.toRadixString(16).substring(2)}',
      customImage: base64Image, // Use base64 image for preview
    );

    return Category(
      category: previewCategory,
      isSelected: false,
    );
  }

  Widget buildCommonFields() {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: buildPreview(),
          ),
        ),
        SizedBox(height: 16),
        NotesInput(
          placeholder: 'Category Title',
          notes: title,
          onChanged: (value) {
            setState(() {
              title = value;
            });
          },
        ),
        SizedBox(height: 16),
        ColorPicker(
          selectedColor: selectedColor,
          onColorSelected: (color) {
            setState(() {
              selectedColor = color;
            });
          },
          colors: currentColors,
        ),
      ],
    );
  }

  void createCategory() {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final categoryData = {
      'title': title,
      'icon': selectedIconName,
      'color': '#${selectedColor.value.toRadixString(16).substring(2)}',
      'customImage': base64Image,
    };

    Api.post('/categories', categoryData, (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category created successfully')),
      );
      Navigator.of(context).pop();
    }, (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create category: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildCommonFields(),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Simple Category'),
              Tab(text: 'Custom Category'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                IconGrid(
                  selectedIconName: selectedIconName,
                  onIconSelected: (iconName) {
                    setState(() {
                      selectedIconName = iconName;
                      selectedImage = null; // Clear selectedImage
                      base64Image = null; // Clear base64 image
                    });
                  },
                ),
                CircularImageCropper(
                  onColorsExtracted: (colors) {
                    setState(() {
                      currentColors = colors;
                    });
                  },
                  onImageCropped: (imageBase64) {
                    setState(() {
                      base64Image = imageBase64; // Store base64 image
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createCategory,
        child: Icon(Icons.check),
      ),
    );
  }
}
