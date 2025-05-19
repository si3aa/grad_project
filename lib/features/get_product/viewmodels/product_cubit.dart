import 'dart:developer' as developer;
import 'package:Herfa/features/get_product/data/models/product_model.dart';
import 'package:Herfa/features/get_product/data/repository/product_api_repository.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:bloc/bloc.dart';

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
          userName: 'Merchant', // Default or fetch from user API
          userHandle: '@merchant',
          userImage: 'assets/images/arrow-small-left.png', // Default image
          productImage: apiProduct.media ?? 'assets/images/product_img.png',
          productName: apiProduct.name ?? 'Unknown Product',
          originalPrice: apiProduct.price ?? 0.0,
          discountedPrice: apiProduct.discountedPrice ??
              0.0, // Now correctly handled as double
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

  /// Handle more options action (placeholder for now).
  void moreOptions(Product product) {
    // Placeholder: In a real app, this might show a menu
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






