
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';

/// Abstrac base state for the ProductCubit.
abstract class ProductState {
  const ProductState();
}

/// Initial state when the cubit is first created.
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// State when products are being loaded.
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// State when products are successfully loaded.
class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
  });
}

/// State when an error occurs while loading or interacting with products.
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);
}
