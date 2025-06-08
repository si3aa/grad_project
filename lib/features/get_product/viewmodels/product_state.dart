import 'package:Herfa/features/get_product/views/widgets/product_class.dart';

abstract class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
  });
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);
}
