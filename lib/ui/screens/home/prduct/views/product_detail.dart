import 'package:flutter/material.dart';

/// Widget to display product details (name, price, description).
class ProductDetails extends StatelessWidget {
  final String productName;
  final double originalPrice;
  final String description;

  const ProductDetails({
    super.key,
    required this.productName,
    required this.originalPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(width: 10),
            Text(
              '\$${originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}