import 'package:Herfa/constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// Widget to display the product image with a shopping cart icon.
class ProductImage extends StatelessWidget {
  final String productImage;
  final VoidCallback onCart;

  const ProductImage({
    super.key,
    required this.productImage,
    required this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: productImage.startsWith('http') 
            ? Image.network(
                productImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  developer.log('Error loading image: $productImage', name: 'ProductImage', error: error);
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
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
                },
              )
            : Image.asset(
                productImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
                  );
                },
              ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onCart,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart,
                color: kPrimaryColor,
                size: 20,
                semanticLabel: 'Add to cart',
              ),
            ),
          ),
        ),
      ],
    );
  }
}


