import 'package:Herfa/ui/screens/home/prduct/models/product_model.dart';
import 'package:Herfa/ui/screens/home/prduct/views/product_class.dart';
import 'package:bloc/bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductInitial()) {
    _loadProducts(); 
  }

  Future<void> _loadProducts() async {
    emit(const ProductLoading());
    try {
      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 2));
      final products = List.generate(
        5,
        (index) => Product(
          userName: 'Salma',
          userHandle: '@sammohammed',
          userImage: 'assets/images/arrow-small-left.png',
          productImage: 'assets/images/product_img.png',
          productName: 'Product Name $index',
          originalPrice: 46.00 + index,
          discountedPrice: 32.00 + index,
          likes: 110 + index,
          comments: 32 + index,
          description: 'whether you are looking for a job or you are a...',
        ),
      );
      emit(ProductLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(const ProductError('Failed to load products'));
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
  }

  /// Handle cart action (placeholder for now).
  void addToCart(Product product) {
    // Placeholder: In a real app, this might add the product to a cart
  }

  /// Handle more options action (placeholder for now).
  void moreOptions(Product product) {
    // Placeholder: In a real app, this might show a menu
  }
}