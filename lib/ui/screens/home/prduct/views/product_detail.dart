import 'package:Herfa/constants.dart';
import 'package:flutter/material.dart';

/// Widget to display product details (name, price, description).
class ProductDetails extends StatefulWidget {
  final String productName;
  final double originalPrice;
  final double? discountedPrice;
  final String description;
  final VoidCallback onCart;

  const ProductDetails({
    super.key,
    required this.productName,
    required this.originalPrice,
    this.discountedPrice,
    required this.description,
    required this.onCart,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isSaved = false;
  bool isInCart = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product details section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    '\$${widget.originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.discountedPrice != null ? Colors.grey : Colors.black,
                      decoration: widget.discountedPrice != null ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (widget.discountedPrice != null) ...[
                    const SizedBox(width: 10),
                    Text(
                      '\$${widget.discountedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        // Action buttons column
        Column(
          children: [
            // Save button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSaved ? kPrimaryColor : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.bookmark,
                  color: isSaved ? Colors.white : Colors.grey.shade600,
                  size: 22,
                  semanticLabel: isSaved ? 'Saved' : 'Save',
                ),
                onPressed: () {
                  setState(() {
                    isSaved = !isSaved;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isSaved ? 'Product saved successfully' : 'Product removed from saved items',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'View',
                        textColor: Colors.white,
                        onPressed: () {
                          if (isSaved) {
                            // Navigate to saved items screen
                            Navigator.pushNamed(context, '/saved');
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Space between buttons
            const SizedBox(height: 12),
            
            // Cart button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isInCart ? kPrimaryColor : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.shopping_cart,
                  color: isInCart ? Colors.white : Colors.grey.shade600,
                  size: 22,
                  semanticLabel: isInCart ? 'Added to cart' : 'Add to cart',
                ),
                onPressed: () {
                  setState(() {
                    isInCart = !isInCart;
                  });
                  
                  // Call the parent's onCart callback
                  widget.onCart();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isInCart ? 'Product added to cart' : 'Product removed from cart',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'View Cart',
                        textColor: Colors.white,
                        onPressed: () {
                          if (isInCart) {
                            // Navigate to cart screen
                            Navigator.pushNamed(context, '/cart');
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


