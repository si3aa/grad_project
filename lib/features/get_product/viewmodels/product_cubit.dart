import 'dart:developer' as developer;
import 'package:Herfa/features/get_product/data/models/product_model.dart';
import 'package:Herfa/features/get_product/data/repository/product_api_repository.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/features/edit_product/views/screens/edit_product_screen.dart';
class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductInitial()) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    emit(const ProductLoading());
    try {
      developer.log('Loading products from repository', name: 'ProductCubit');
      final repository = ProductApiRepository();
      final apiProducts = await repository.getProducts();

      developer.log('Received ${apiProducts.length} products from API',
          name: 'ProductCubit');

      // Convert API products to UI Product model
      final products = apiProducts.map((apiProduct) {
        developer.log(
            'Processing product: ${apiProduct.id} - ${apiProduct.name}',
            name: 'ProductCubit');
        return Product(
         id: apiProduct.id!,
          userName: 'Merchant', // Default or fetch from user API
          userHandle: '@merchant',
          userImage: 'assets/images/arrow-small-left.png', // Default image
          productImage: apiProduct.media ?? 'assets/images/product_img.png',
          productName: apiProduct.name ?? 'Unknown Product',
          originalPrice: apiProduct.price ?? 0.0,
          discountedPrice: apiProduct.discountedPrice ?? 0.0,
          likes: 0, // Default value since it's not from API
          comments: 0, // Default value since it's not from API
          title: apiProduct.shortDescription ?? '',
          description: apiProduct.longDescription ?? '',
          quantity: apiProduct.quantity ?? 0, 
        );
      }).toList();

      developer.log('Converted ${products.length} products to UI model',
          name: 'ProductCubit');

      emit(ProductLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      developer.log('Error loading products', name: 'ProductCubit', error: e);
      emit(ProductError('Failed to load products: $e'));
    }
  }

  /// Filter products based on the search query.
  void filterProducts(String query) {
    final state = this.state;
    if (state is ProductLoaded) {
      final filtered = state.products
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(ProductLoaded(
        products: state.products,
        filteredProducts: filtered,
      ));
    }
  }

  void likeProduct(Product product) {
    final state = this.state;
    if (state is ProductLoaded) {
      product.likes++;
      emit(ProductLoaded(
        products: state.products,
        filteredProducts: List.from(state.filteredProducts),
      ));
    }
  }

  /// Handle comment action (placeholder for now).
  void commentProduct(Product product) {
    final state = this.state;
    if (state is ProductLoaded) {
      product.comments++;
      emit(ProductLoaded(
        products: state.products,
        filteredProducts: List.from(state.filteredProducts),
      ));
    }
  }

  /// Handle cart action (placeholder for now).
  void addToCart(Product product) {
    // Placeholder: In a real app, this might add the product to a cart
  }

  /// Handle more options action for a product
  void moreOptions(Product product, BuildContext context) {
    // Show bottom sheet with options
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
                _navigateToEditProduct(context, product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Product'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, product);
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
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Product'),
              onTap: () {
                Navigator.pop(context);
                // Implement share product functionality
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
      ),
    );
  }

  /// Navigate to edit product screen
  void _navigateToEditProduct(BuildContext context, Product product) {
    // Store a reference to the ScaffoldMessengerState
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          productId: product.id,
        ),
      ),
    ).then((edited) {
      if (edited == true) {
        // Refresh product data if edited
        _loadProducts();
        
        // Show success message using the stored reference
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, Product product) {
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
              deleteProduct(context, product);
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

  /// Delete a product - public method that can be called from UI
  Future<void> deleteProduct(BuildContext context, Product product) async {
    // Store a reference to the ScaffoldMessengerState to avoid using context after widget disposal
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      // Show loading indicator
      final loadingSnackBar = SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text('Deleting ${product.productName}...'),
          ],
        ),
        duration: const Duration(seconds: 60), // Long duration as we'll dismiss it manually
      );
      
      scaffoldMessenger.showSnackBar(loadingSnackBar);
      
      // Call API to delete the product
      final repository = ProductApiRepository();
      final success = await repository.deleteProduct(product.id.toString());
      
      // Hide the loading indicator
      scaffoldMessenger.hideCurrentSnackBar();
      
      if (success) {
        // Update local state if deletion was successful
        final currentState = this.state;
        if (currentState is ProductLoaded) {
          // Remove the product from the lists
          final updatedProducts = currentState.products.where((p) => 
            p.id != product.id).toList();
          
          final updatedFilteredProducts = currentState.filteredProducts.where((p) => 
            p.id != product.id).toList();
          
          // Update the state
          emit(ProductLoaded(
            products: updatedProducts,
            filteredProducts: updatedFilteredProducts,
          ));
        }
        
        // Show success message
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Show error message
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Failed to delete product. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Hide the loading indicator
      scaffoldMessenger.hideCurrentSnackBar();
      
      // Show error message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error deleting product: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      
      developer.log('Error deleting product', name: 'ProductCubit', error: e);
    }
  }

  /// Update a product's quantity in the state
  void updateProductQuantity(Product updatedProduct) {
    final state = this.state;
    if (state is ProductLoaded) {
      final updatedProducts = state.products.map((product) {
        if (product.productName == updatedProduct.productName) {
          return updatedProduct;
        }
        return product;
      }).toList();
      
      developer.log('Updated quantity for product: ${updatedProduct.productName}', 
          name: 'ProductCubit');
      
      emit(ProductLoaded(
        products: updatedProducts,
        filteredProducts: updatedProducts.where((product) => 
          state.filteredProducts.any((p) => p.productName == product.productName)
        ).toList(),
      ));
    }
  }
}






