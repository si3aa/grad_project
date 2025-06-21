// iore_for_file: unnecessary_null_comparison

import 'package:Herfa/constants.dart';
import 'package:Herfa/features/comments/data/repository/comment_repository.dart';
import 'package:Herfa/features/comments/viewmodels/comment_cubit.dart';
import 'package:Herfa/features/edit_product/views/screens/edit_product_screen.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/features/get_product/viewmodels/product_state.dart'
    as viewmodels;
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/product_rating/product_rating_mvvm.dart'
    show ProductRatingBar;
import 'package:Herfa/features/product_rating/token_helper.dart';
import 'package:Herfa/features/saved_products/viewmodels/states/saved_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedQuantity = 1;
  bool isInCart = false;
  String? couponCode;
  double discountAmount = 0.0;
  final TextEditingController _couponController = TextEditingController();
  bool _isDescriptionExpanded = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _decreaseQuantity() {
    if (selectedQuantity > 1) {
      setState(() {
        selectedQuantity--;
      });
    }
  }

  void _increaseQuantity() {
    // Only allow increasing if there's available stock
    if (selectedQuantity < widget.product.quantity) {
      setState(() {
        selectedQuantity++;
      });
    } else {
      // Show a message that there's no more stock available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum available quantity reached'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

// Helper method to build full name (add this at the top of your class)
  String buildFullName(String firstName, String lastName) {
    // Handle null or empty values
    final cleanFirstName = (firstName).trim();
    final cleanLastName = (lastName).trim();

    if (cleanFirstName.isEmpty && cleanLastName.isEmpty) {
      return 'Unknown User';
    }

    if (cleanFirstName.isEmpty) {
      return capitalizeFirstLetter(cleanLastName);
    }

    if (cleanLastName.isEmpty) {
      return cleanFirstName;
    }

    return '$cleanFirstName ${capitalizeFirstLetter(cleanLastName)}';
  }

  void _navigateToEditProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          productId: 1,
        ),
      ),
    ).then((edited) {
      if (edited == true) {
        // Refresh product data if edited
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // ignore: unused_element
  void _showEditOptions(Product product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Product Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.edit, color: kPrimaryColor),
              title: const Text('Edit Product'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEditProduct(product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Product'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${product.productName}"?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone and the product will be permanently removed from your store.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              // Get the ProductCubit before any navigation happens
              final productCubit = context.read<ProductCubit>();

              // Delete the product using the stored reference
              productCubit.deleteProduct(context, product);

              // Navigate back to the previous screen after deletion
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _applyCoupon() {
    // In a real app, you would validate the coupon code with an API
    // For this example, we'll just apply a fixed discount for any coupon
    if (_couponController.text.isNotEmpty) {
      setState(() {
        couponCode = _couponController.text;
        // Apply a 10% discount for demonstration
        final price = widget.product.discountedPrice;
        discountAmount = price * 0.1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon "$couponCode" applied successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _addToCart() {
    // Get the ProductCubit instance
    final productCubit = context.read<ProductCubit>();

    // Create a copy of the product with updated quantity
    final updatedProduct = Product(
      userFirstName: widget.product.userFirstName,
      userUsername: widget.product.userUsername,
      userLastName: widget.product.userLastName,
      userImage: widget.product.userImage,
      productImage: widget.product.productImage,
      productName: widget.product.productName,
      originalPrice: widget.product.originalPrice,
      discountedPrice: widget.product.discountedPrice,
      title: widget.product.title,
      description: widget.product.description,
      quantity: widget.product.quantity -
          selectedQuantity, // Decrease the available quantity
      id: widget.product.id,
    );

    // Update the product in the state
    productCubit.updateProductQuantity(updatedProduct);

    setState(() {
      isInCart = true;
      // Reset selected quantity to 1 after adding to cart
      selectedQuantity = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.productName} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'product-${widget.product.productName}',
      child: widget.product.productImage.startsWith('http')
          ? Image.network(
              widget.product.productImage,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                developer.log(
                    'Error loading image: ${widget.product.productImage}',
                    name: 'ProductDetailScreen',
                    error: error);
                return Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image,
                          size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Image could not be loaded',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: kPrimaryColor,
                    ),
                  ),
                );
              },
            )
          : Image.asset(
              widget.product.productImage,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                developer.log(
                    'Error loading asset image: ${widget.product.productImage}',
                    name: 'ProductDetailScreen',
                    error: error);
                return Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image,
                          size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Image could not be loaded',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              child: Text(
                _isDescriptionExpanded ? 'Show Less' : 'Show More',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          crossFadeState: _isDescriptionExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product.discountedPrice;
    final totalPrice = (price - discountAmount) * selectedQuantity;

    return BlocProvider(
      create: (context) => CommentCubit(CommentRepository()),
      child: BlocBuilder<ProductCubit, viewmodels.ProductState>(
        builder: (context, state) {
          // If the state is loaded, we can access the updated product
          if (state is viewmodels.ProductLoaded) {
            // Find the current product in the updated list
            final currentProduct = state.products.firstWhere(
              (p) => p.productName == widget.product.productName,
              orElse: () => widget.product,
            );

            return Scaffold(
              appBar: AppBar(
                title: const Text('Product Details'),
                actions: [
                  BlocBuilder<SavedProductCubit, SavedProductState>(
                    builder: (context, savedState) {
                      bool isProductSaved = false;

                      if (savedState is SavedProductDetailsLoaded) {
                        isProductSaved = savedState.productDetails
                            .any((p) => p.id == widget.product.id.toString());
                      }

                      return IconButton(
                        icon: Icon(
                          isProductSaved
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: isProductSaved ? kPrimaryColor : null,
                        ),
                        onPressed: isProductSaved
                            ? null // Disable click when already saved
                            : () {
                                // Only allow saving if not already saved
                                final savedProductCubit =
                                    context.read<SavedProductCubit>();
                                savedProductCubit
                                    .saveProduct(widget.product.id.toString());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Product saved'),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'View',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        // Navigate to saved items screen
                                        Navigator.pushNamed(context, '/saved');
                                      },
                                    ),
                                  ),
                                );
                              },
                      );
                    },
                  ),
                  // Add edit button for product owner
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showEditOptions(currentProduct);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image with error handling
                    _buildProductImage(),
                    // Product Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Seller Info
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(currentProduct.userImage),
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    buildFullName(currentProduct.userFirstName,
                                        currentProduct.userLastName),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    currentProduct.userUsername,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement contact seller functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Contact Seller'),
                              ),
                            ],
                          ),
                          // Product Name and Title
                          Text(
                            currentProduct.productName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (currentProduct.title.isNotEmpty) ...[
                            Text(
                              currentProduct.title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Price information
                          Row(
                            children: [
                              ...[
                                Text(
                                  '\$${currentProduct.originalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                '\$${(currentProduct.discountedPrice).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  // ignore: unnecessary_null_comparison
                                  color: currentProduct.discountedPrice != null
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${(100 - (currentProduct.discountedPrice / currentProduct.originalPrice * 100)).toStringAsFixed(0)}% OFF',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Description with expandable text
                          _buildDescription(),

                          const SizedBox(height: 24),

                          // Quantity Selector
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _decreaseQuantity,
                                      color: selectedQuantity > 1
                                          ? kPrimaryColor
                                          : Colors.grey,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        '$selectedQuantity',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: selectedQuantity <
                                              currentProduct.quantity
                                          ? _increaseQuantity
                                          : null,
                                      color: selectedQuantity <
                                              currentProduct.quantity
                                          ? kPrimaryColor
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Available: ${currentProduct.quantity}',
                                style: TextStyle(
                                  color: currentProduct.quantity > 0
                                      ? Colors.grey.shade600
                                      : Colors.red,
                                  fontWeight: currentProduct.quantity > 0
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Coupon Code
                          const Text(
                            'Apply Coupon',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _couponController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter coupon code',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _applyCoupon,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                child: const Text('Apply'),
                              ),
                            ],
                          ),

                          if (couponCode != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Coupon "$couponCode" applied: -\$${discountAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      couponCode = null;
                                      discountAmount = 0.0;
                                      _couponController.clear();
                                    });
                                  },
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Order Summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal'),
                                    Text(
                                        '\$${(price * selectedQuantity).toStringAsFixed(2)}'),
                                  ],
                                ),
                                if (discountAmount > 0) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Discount'),
                                      Text(
                                          '-\$${(discountAmount * selectedQuantity).toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Add rating stars at the end of the screen
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: FutureBuilder<String?>(
                              future: TokenHelper.getToken(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text(
                                      'Unable to rate: Not authenticated');
                                }
                                return ProductRatingBar(
                                  productId: currentProduct.id,
                                  token: snapshot.data!,
                                  initialRating:
                                      0, // Replace with actual rating if available
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Star Rating Widget at the bottom
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: StarRatingWidget(
                    //     productId: currentProduct.id,
                    //     token:
                    //         'YOUR_USER_TOKEN', // Replace with actual user token
                    //     productOwnerId: currentProduct
                    //         .userUsername, // Or the correct owner id
                    //     starSize: 36.0,
                    //     activeColor: Colors.amber,
                    //     inactiveColor: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed:
                            currentProduct.quantity > 0 ? _addToCart : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade400,
                        ),
                        child: Text(
                          currentProduct.quantity > 0
                              ? (isInCart ? 'ADDED TO CART' : 'ADD TO CART')
                              : 'OUT OF STOCK',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // If the state is not loaded, show a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
