// iore_for_file: unnecessary_null_comparison

import 'package:Herfa/constants.dart';
import 'package:Herfa/features/comments/data/repository/comment_repository.dart';
import 'package:Herfa/features/comments/viewmodels/comment_cubit.dart';
import 'package:Herfa/features/get_product/views/widgets/product_comments.dart';
import 'package:Herfa/features/edit_product/views/screens/edit_product_screen.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/features/get_product/viewmodels/product_state.dart'
    as viewmodels;
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/saved_products/viewmodels/states/saved_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';
import 'package:Herfa/features/deals/data/repository/deal_repository.dart';
import 'package:Herfa/features/deals/viewmodels/deal_cubit.dart';
import 'package:Herfa/features/deals/views/make_deal_screen.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/deals/data/data_source/deal_remote_data_source.dart';
import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:Herfa/features/get_me/current_user_cubit.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

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

  Data? currentUser;

  @override
  void initState() {
    super.initState();
    // Fetch user info if not already loaded
    final cubit = context.read<CurrentUserCubit>();
    if (cubit.state is! CurrentUserLoaded) {
      cubit.fetchCurrentUser();
    }
  }

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
    final userRole = currentUser?.role;
    if (userRole == null || userRole == 'USER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to edit products.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/edit_product',
      arguments: {'product': product},
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

  void _showEditOptions(Product product) {
    final userRole = currentUser?.role;
    if (userRole == null || userRole == 'USER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to edit or delete products.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
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
    final userRole = currentUser?.role;
    if (userRole == null || userRole == 'USER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to delete products.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
    // Use CartCubit to add item to cart with quantity and coupon
    final cartCubit = context.read<CartCubit>();
    cartCubit.addItem(CartItem(
      id: widget.product.id,
      name: widget.product.productName,
      price: (widget.product.discountedPrice - discountAmount),
      imageUrl: widget.product.productImage,
      quantity: selectedQuantity,
      couponCode: couponCode,
    ));
    setState(() {
      isInCart = true;
      selectedQuantity = 1;
    });
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text(
              'Added to Cart!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.product.productName} x$selectedQuantity',
              style: const TextStyle(fontSize: 16),
            ),
            if (couponCode != null) ...[
              const SizedBox(height: 4),
              Text('Coupon: $couponCode',
                  style: const TextStyle(color: Colors.green)),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Go to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocProvider(
                create: (context) => CommentCubit(CommentRepository())
                  ..fetchComments(widget.product.id.toString()),
                child: ProductComments(
                  productId: widget.product.id.toString(),
                ),
              ),
            ),
          ],
        ),
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
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CurrentUserLoaded) {
          currentUser = state.user;
        } else if (state is CurrentUserError) {
          return Center(child: Text('Error: \\${state.message}'));
        }
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
                            isProductSaved = savedState.productDetails.any(
                                (p) => p.id == widget.product.id.toString());
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
                                    savedProductCubit.saveProduct(
                                        widget.product.id.toString());

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Product saved'),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'View',
                                          textColor: Colors.white,
                                          onPressed: () {
                                            // Navigate to saved items screen
                                            Navigator.pushNamed(
                                                context, '/saved');
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
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage(currentProduct.userImage),
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentProduct.userFirstName} ${currentProduct.userLastName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        currentProduct.userUsername ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Get token (as in other screens)
                                      final token =
                                          await AuthSharedPrefLocalDataSource()
                                              .getToken();
                                      if (token == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Not authenticated!')),
                                        );
                                        return;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (_) => DealCubit(
                                                DealRepository(
                                                  DealRemoteDataSource(Dio(
                                                      BaseOptions(
                                                          baseUrl:
                                                              'https://zygotic-marys-herfa-c2dd67a8.koyeb.app'))),
                                                ),
                                              ),
                                              child: MakeDealScreen(
                                                  productId: currentProduct.id,
                                                  token: token),
                                            ),
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text('Make Deal'),
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
                                  ...[
                                    Text(
                                      '${currentProduct.originalPrice.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    '${(currentProduct.discountedPrice).toStringAsFixed(2)} EGP',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      // ignore: unnecessary_null_comparison
                                      color:
                                          currentProduct.discountedPrice != null
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
                                      border: Border.all(
                                          color: Colors.grey.shade300),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                    const SizedBox(width: 2),
                                    Text(
                                      'Coupon "$couponCode" applied: -${discountAmount.toStringAsFixed(2)}EGP',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                                      child: const Text(
                                        'Remove',
                                        style: TextStyle(fontSize: 9),
                                      ),
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
                                            '${(price * selectedQuantity).toStringAsFixed(2)} EGP'),
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
                                              '-${(discountAmount * selectedQuantity).toStringAsFixed(2)} EGP'),
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
                                          '${totalPrice.toStringAsFixed(2)} EGP',
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
                            '${totalPrice.toStringAsFixed(2)} EGP',
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
      },
    );
  }
}
