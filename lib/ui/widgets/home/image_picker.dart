import 'package:flutter/material.dart';
class ImagePickerWidget extends StatelessWidget {
  final List<String> images;
  final Function(String) onAddImage;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...images.map((image) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )),
        GestureDetector(
          onTap: () {
            onAddImage(''); 
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset('assets/images/plus.png', width: 30, height: 30),
            ),
          ),
        ),
      ],
    );
  }
}