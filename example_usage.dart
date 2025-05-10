import 'package:Herfa/ui/widgets/home/image_picker.dart';
import 'package:flutter/material.dart';

class MyFormScreen extends StatefulWidget {
  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  // State to hold the list of images
  List<String> _images = [];

  // Add image function
  void _addImage(String imagePath) {
    setState(() {
      _images = [imagePath]; // Replace any existing image
    });
  }

  // Delete image function - make sure this actually removes the image
  void _deleteImage(String imagePath) {
    setState(() {
      _images.remove(imagePath);
    });
    print("Image deleted: $imagePath"); // Add logging to verify it's called
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Product Image', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ImagePickerWidget(
              images: _images,
              onAddImage: _addImage,
              onDeleteImage: _deleteImage, // Make sure this is passed
              maxImages: 1,
            ),
          ],
        ),
      ),
    );
  }
}

