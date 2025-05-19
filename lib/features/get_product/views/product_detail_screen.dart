// ignore_for_file: unnecessary_null_comparison

import 'package:Herfa/constants.dart';
import 'package:Herfa/features/edit_product/views/screens/edit_product_screen.dart';
import 'package:Herfa/features/get_product/data/models/product_model.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

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
  bool isSaved = false;
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

  void _navigateToEditProduct(Product product) {
    // Navigate to edit product screen with product ID
    // Since the Product class doesn't have an ID, we'll use a hardcoded ID for now
    // In a real app, you would get the ID from the API
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
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: const Text('Hide Product'),
              onTap: () {
                Navigator.pop(context);
                // Implement hide product functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product hidden from marketplace'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete product functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
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
      userName: widget.product.userName,
      userHandle: widget.product.userHandle,
      userImage: widget.product.userImage,
      productImage: widget.product.productImage,
      productName: widget.product.productName,
      originalPrice: widget.product.originalPrice,
      discountedPrice: widget.product.discountedPrice,
      likes: widget.product.likes,
      comments: widget.product.comments,
      title: widget.product.title,
      description: widget.product.description,
      quantity: widget.product.quantity - selectedQuantity, // Decrease the available quantity
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
              developer.log('Error loading image: ${widget.product.productImage}',
                name: 'ProductDetailScreen', error: error);
              return Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 60, color: Colors.grey),
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
              developer.log('Error loading asset image: ${widget.product.productImage}',
                name: 'ProductDetailScreen', error: error);
              return Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 60, color: Colors.grey),
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

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        // If the state is loaded, we can access the updated product
        if (state is ProductLoaded) {
          // Find the current product in the updated list
          final currentProduct = state.products.firstWhere(
            (p) => p.productName == widget.product.productName,
            orElse: () => widget.product,
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Details'),
              actions: [
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: isSaved ? kPrimaryColor : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved ? 'Product saved' : 'Product removed from saved items',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing product...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
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
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(currentProduct.userImage),
                              radius: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentProduct.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  currentProduct.userHandle,
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

                        const SizedBox(height: 24),

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
                            if (currentProduct.discountedPrice != null) ...[
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
                                color: currentProduct.discountedPrice != null ? Colors.red : Colors.black,
                              ),
                            ),
                            if (currentProduct.discountedPrice != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: _decreaseQuantity,
                                    color: selectedQuantity > 1 ? kPrimaryColor : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    onPressed: selectedQuantity < currentProduct.quantity
                                        ? _increaseQuantity
                                        : null,
                                    color: selectedQuantity < currentProduct.quantity
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
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              child: const Text('Apply'),
                            ),
                          ],
                        ),

                        if (couponCode != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 16),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal'),
                                  Text('\$${(price * selectedQuantity).toStringAsFixed(2)}'),
                                ],
                              ),
                              if (discountAmount > 0) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Discount'),
                                    Text('-\$${(discountAmount * selectedQuantity).toStringAsFixed(2)}'),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
                    ),
                  ),
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
                      onPressed: currentProduct.quantity > 0 ? _addToCart : null,
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
    );
  }
}














