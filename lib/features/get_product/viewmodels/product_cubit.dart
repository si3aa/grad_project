import 'dart:developer' as developer;
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/get_product/data/repository/product_api_repository.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/viewmodels/product_state.dart'
    as viewmodels;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class ProductCubit extends Cubit<viewmodels.ProductState> {
  ProductCubit() : super(const viewmodels.ProductInitial()) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    emit(const viewmodels.ProductLoading());
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
          userFirstName: apiProduct.userFirstName ?? '',
          userLastName: apiProduct.userLastName ?? '',
          userUsername: apiProduct.userUsername ?? '',
          userImage: 'assets/images/arrow-small-left.png', // Default image
          productImage: apiProduct.media ?? 'assets/images/product_img.png',
          productName: apiProduct.name ?? 'Unknown Product',
          originalPrice: apiProduct.price ?? 0.0,
          discountedPrice: apiProduct.discountedPrice ?? 0.0,
          title: apiProduct.shortDescription ?? '',
          description: apiProduct.longDescription ?? '',
          quantity: apiProduct.quantity ?? 0, 
        );
      }).toList();

      developer.log('Converted ${products.length} products to UI model',
          name: 'ProductCubit');

      emit(viewmodels.ProductLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      developer.log('Error loading products', name: 'ProductCubit', error: e);
      emit(viewmodels.ProductError('Failed to load products: $e'));
    }
  }

  /// Filter products based on the search query.
  void filterProducts(String query) {
    final state = this.state;
    if (state is viewmodels.ProductLoaded) {
      final filtered = state.products
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(viewmodels.ProductLoaded(
        products: state.products,
        filteredProducts: filtered,
      ));
    }
  }
  void addToCart(Product product) {
    // Placeholder: In a real app, this might add the product to a cart
  }

  /// Handle more options action for a product
  void moreOptions(Product product, BuildContext context) {
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

    // Navigate to the edit product screen
    Navigator.pushNamed(
      context,
      Routes.editProductRoute,
      arguments: {
        'product': product,
        'productId': product.id,
      },
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
        duration: const Duration(
            seconds: 60), // Long duration as we'll dismiss it manually
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
        if (currentState is viewmodels.ProductLoaded) {
          // Remove the product from the lists
          final updatedProducts =
              currentState.products.where((p) => p.id != product.id).toList();

          final updatedFilteredProducts = currentState.filteredProducts
              .where((p) => p.id != product.id)
              .toList();

          // Update the state
          emit(viewmodels.ProductLoaded(
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
    if (state is viewmodels.ProductLoaded) {
      final updatedProducts = state.products.map((product) {
        if (product.productName == updatedProduct.productName) {
          return updatedProduct;
        }
        return product;
      }).toList();

      developer.log(
          'Updated quantity for product: ${updatedProduct.productName}',
          name: 'ProductCubit');

      emit(viewmodels.ProductLoaded(
        products: updatedProducts,
        filteredProducts: updatedProducts
            .where((product) => state.filteredProducts
                .any((p) => p.productName == product.productName))
            .toList(),
      ));
    }
  }

  /// Update a product
  Future<bool> updateProduct(
      String productId, Map<String, dynamic> productData) async {
    try {
      emit(const viewmodels.ProductLoading());
      final repository = ProductApiRepository();

      // Convert product data to match API requirements
      final apiData = {
        'name': productData['name'],
        'shortDescription': productData['title'],
        'longDescription': productData['description'],
        'price': productData['price'].toString(),
        'quantity': productData['quantity'].toString(),
        'categoryId': productData['categoryId'].toString(),
        'active': 'true',
        'colors': productData['colors']?.toString() ?? '[]',
      };

      // Step 1: Update the existing product
      final updateSuccess = await repository.updateProduct(productId, apiData);
      if (!updateSuccess) {
        emit(viewmodels.ProductError('Failed to update product'));
        return false;
      }

      // Step 2: Delete the old product
      final deleteSuccess = await repository.deleteProduct(productId);
      if (!deleteSuccess) {
        emit(viewmodels.ProductError('Failed to delete old product'));
        return false;
      }

      // Step 3: Create new product with updated data
      final newProductData = {
        ...apiData,
        'id':
            DateTime.now().millisecondsSinceEpoch.toString(), // Generate new ID
      };

      // Add the new product (using the same API endpoint)
      final addSuccess =
          await repository.updateProduct(newProductData['id'], newProductData);
      if (!addSuccess) {
        emit(viewmodels.ProductError('Failed to add updated product'));
        return false;
      }

      // Update local state
      final currentState = this.state;
      if (currentState is viewmodels.ProductLoaded) {
        final updatedProducts = currentState.products.map((product) {
          if (product.id.toString() == productId) {
            return Product(
              id: product.id,
              userFirstName: product.userFirstName,
              userLastName:product.userLastName,
              userUsername: product.userUsername,
              userImage: product.userImage,
              productImage: product.productImage,
              productName: product.productName,
              originalPrice: product.originalPrice,
              discountedPrice: product.discountedPrice,
              title: product.title,
              description: product.description,
              quantity: product.quantity, 
              
            );
          }
          return product;
        }).toList();

        emit(viewmodels.ProductLoaded(
          products: updatedProducts,
          filteredProducts: updatedProducts,
        ));
      }
      return true;
    } catch (e) {
      developer.log('Error updating product', name: 'ProductCubit', error: e);
      emit(viewmodels.ProductError('Failed to update product: $e'));
      return false;
    }
  }

  /// Load products for a specific merchant
  Future<void> loadMerchantProducts(String merchantId) async {
    emit(const viewmodels.ProductLoading());
    try {
      developer.log('Loading merchant products from repository',
          name: 'ProductCubit');
      final repository = ProductApiRepository();
      final apiProducts = await repository.getMerchantProducts(merchantId);

      developer.log('Received ${apiProducts.length} merchant products from API',
          name: 'ProductCubit');

      // Convert API products to UI Product model
      final products = apiProducts.map((apiProduct) {
        developer.log(
            'Processing merchant product: ${apiProduct.id} - ${apiProduct.name}',
            name: 'ProductCubit');
        return Product(
          id: apiProduct.id!,
          userFirstName: apiProduct.userFirstName ?? '',
          userUsername: apiProduct.userUsername ?? '',
          userLastName:apiProduct.userLastName ?? '',
          userImage: 'assets/images/arrow-small-left.png', // Default image
          productImage: apiProduct.media ?? 'assets/images/product_img.png',
          productName: apiProduct.name ?? 'Unknown Product',
          originalPrice: apiProduct.price ?? 0.0,
          discountedPrice: apiProduct.discountedPrice ?? 0.0,
          title: apiProduct.shortDescription ?? '',
          description: apiProduct.longDescription ?? '',
          quantity: apiProduct.quantity ?? 0, 
        );
      }).toList();

      developer.log(
          'Converted ${products.length} merchant products to UI model',
          name: 'ProductCubit');

      emit(viewmodels.ProductLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      developer.log('Error loading merchant products',
          name: 'ProductCubit', error: e);
      emit(viewmodels.ProductError('Failed to load merchant products: $e'));
    }
  }

  // Make this method public so it can be called from UI
  Future<void> loadProducts() async {
    return _loadProducts();
  }
}
