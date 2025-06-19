import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'dart:io';

/// Widget to display the product image with a shopping cart icon.
class ProductImage extends StatelessWidget {
  final String productImage;

  const ProductImage({
    super.key,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: _buildImage(context),
    );
  }

  Widget _buildImage(BuildContext context) {
    // Check if it's a network image (starts with http or https)
    if (productImage.startsWith('http')) {
      return Image.network(
        productImage,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          developer.log('Error loading image: $productImage', name: 'ProductImage', error: error);
          return _buildErrorPlaceholder(context);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder(context, loadingProgress);
        },
      );
    } 
    // Check if it's a local file path (not starting with 'assets/')
    else if (!productImage.startsWith('assets/') && productImage.isNotEmpty) {
      return Image.file(
        File(productImage),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          developer.log('Error loading file image: $productImage', name: 'ProductImage', error: error);
          return _buildErrorPlaceholder(context);
        },
      );
    } 
    // Otherwise, treat as asset image
    else {
      return Image.asset(
        productImage,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder(context);
        },
      );
    }
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context, ImageChunkEvent loadingProgress) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }
}



