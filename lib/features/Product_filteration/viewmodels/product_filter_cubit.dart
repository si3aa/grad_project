import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_filter_repository.dart';

abstract class ProductFilterState {}

class ProductFilterInitial extends ProductFilterState {}

class ProductFilterLoading extends ProductFilterState {}

class ProductFilterLoaded extends ProductFilterState {
  final List<dynamic> products;
  ProductFilterLoaded(this.products);
}

class ProductFilterError extends ProductFilterState {
  final String message;
  ProductFilterError(this.message);
}

class ProductFilterCubit extends Cubit<ProductFilterState> {
  final ProductFilterRepository repository;
  ProductFilterCubit(this.repository) : super(ProductFilterInitial());

  Future<void> fetchProducts(int categoryId) async {
    emit(ProductFilterLoading());
    try {
      final products = await repository.fetchProductsByCategory(categoryId);
      emit(ProductFilterLoaded(products));
    } catch (e) {
      emit(ProductFilterError(e.toString()));
    }
  }
}
