import 'package:Herfa/constants.dart';
import 'package:flutter/material.dart';

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
          child: Image.asset(
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
