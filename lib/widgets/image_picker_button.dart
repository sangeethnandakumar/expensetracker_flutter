import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(String) onImageSelected;

  const ImagePickerButton({Key? key, required this.onImageSelected}) : super(key: key);

  Future<void> _pickImage() async {
    print('Attempting to pick an image...');
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image picked: ${image.path}');
        onImageSelected(image.path);
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _pickImage,
      icon: Icon(Icons.image),
      label: Text('Select Image'),
    );
  }
}