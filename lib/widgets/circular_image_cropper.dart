import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';

class CircularImageCropper extends StatefulWidget {
  final Function(List<Color>) onColorsExtracted;
  final Function(String) onImageCropped;

  CircularImageCropper({required this.onColorsExtracted, required this.onImageCropped});

  @override
  _CircularImageCropperState createState() => _CircularImageCropperState();
}

class _CircularImageCropperState extends State<CircularImageCropper> {
  String? _imagePath;
  bool _enableCropping = true;

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (_enableCropping) {
        _cropImage(pickedFile.path);
      } else {
        _convertToBase64(pickedFile.path);
      }
    }
  }

  Future<void> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue.shade200,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _imagePath = croppedFile.path;
      });
      final bytes = await File(croppedFile.path).readAsBytes();
      final base64Image = 'data:image/png;base64,' + base64Encode(bytes);
      widget.onImageCropped(base64Image);
      _extractColors(bytes);
    }
  }

  Future<void> _convertToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = 'data:image/png;base64,' + base64Encode(bytes);
    setState(() {
      _imagePath = imagePath;
    });
    widget.onImageCropped(base64Image);
    _extractColors(bytes);
  }

  Future<void> _extractColors(Uint8List bytes) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      MemoryImage(bytes),
    );
    List<Color> colors = paletteGenerator.colors.toList();
    widget.onColorsExtracted(colors);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Cropping',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'If the image is transparent, try disabling crop.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Switch(
                    value: _enableCropping,
                    onChanged: (value) {
                      setState(() {
                        _enableCropping = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _selectImage,
            child: Container(
              width: 300, // Set width for the image container
              height: 200, // Set height for the image container
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8), // Rounded corners
                image: _imagePath != null
                    ? DecorationImage(
                  image: FileImage(File(_imagePath!)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _imagePath == null
                  ? Center(
                child: Text(
                  'Tap to select an image',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
