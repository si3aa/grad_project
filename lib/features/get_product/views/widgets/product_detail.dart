import 'dart:developer';
import 'package:Herfa/core/constants/colors.dart';
import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/saved_products/viewmodels/states/saved_product_state.dart';

/// Widget to display product details (name, price, description).
class ProductDetails extends StatefulWidget {
  final String productId;
  final String productName;
  final double originalPrice;
  final double? discountedPrice;
  final String description;
  final VoidCallback onCart;
  final bool isSaved;

  const ProductDetails({
    Key? key,
    required this.productId,
    required this.productName,
    required this.originalPrice,
    this.discountedPrice,
    required this.description,
    required this.onCart,
    required this.isSaved,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isInCart = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Product info column
        // Product info column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${widget.originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.discountedPrice != null
                          ? Colors.grey.shade500
                          : Colors.black,
                      decoration: widget.discountedPrice != null
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (widget.discountedPrice != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '\$${widget.discountedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${widget.discountedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
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
            BlocConsumer<SavedProductCubit, SavedProductState>(
              listener: (context, state) {
                log('SavedProductState: $state');
                if (state is SavedProductSuccess) {
                  log('Product save status changed: ${state.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'View',
                        textColor: Colors.white,
                        onPressed: () {
                          if (state.message.contains('saved')) {
                            // Navigate to saved items screen
                            Navigator.pushNamed(context, '/saved');
                          }
                        },
                      ),
                    ),
                  );
                } else if (state is SavedProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                bool isLoading = state is SavedProductLoading;

                // Check if this product is in the saved list
                bool isSaved = false;
                if (state is SavedProductDetailsLoaded) {
                  isSaved =
                      state.productDetails.any((p) => p.id == widget.productId);
                }

                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSaved ? kPrimaryColor : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isSaved ? Colors.white : kPrimaryColor,
                            ),
                          ),
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color:
                                isSaved ? Colors.white : Colors.grey.shade600,
                            size: 22,
                            semanticLabel: isSaved ? 'Saved' : 'Save',
                          ),
                          onPressed: isSaved
                              ? null // Disable click when already saved
                              : () {
                                  // Only allow saving if not already saved
                                  context
                                      .read<SavedProductCubit>()
                                      .saveProduct(widget.productId);
                                },
                        ),
                );
              },
            ),

            // Space between buttons
            const SizedBox(height: 12),

            // Cart button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.grey.shade600,
                  size: 22,
                  semanticLabel: 'Add to cart',
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
                        isInCart
                            ? 'Product added to cart'
                            : 'Product removed from cart',
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
