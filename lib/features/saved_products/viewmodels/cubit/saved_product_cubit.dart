import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/saved_product_repository.dart';
import '../states/saved_product_state.dart';

class SavedProductCubit extends Cubit<SavedProductState> {
  final SavedProductRepository _repository;

  SavedProductCubit({SavedProductRepository? repository})
      : _repository = repository ?? SavedProductRepository(),
        super(SavedProductInitial());

  Future<void> saveProduct(String productId) async {
    emit(SavedProductLoading());
    log('SavedProductCubit: Saving product $productId');
    try {
      final success = await _repository.saveProduct(productId);
      if (success) {
        log('SavedProductCubit: Product saved successfully');
        emit(SavedProductSuccess(message: 'Product saved successfully'));
      } else {
        log('SavedProductCubit: Failed to save product');
        emit(SavedProductError(message: 'Failed to save product'));
      }
    } catch (e) {
      log('SavedProductCubit: Error saving product: $e');
      emit(SavedProductError(message: e.toString()));
    }
  }

  Future<void> removeSavedProduct(String productId) async {
    emit(SavedProductLoading());
    log('SavedProductCubit: Removing saved product $productId');
    try {
      final success = await _repository.removeSavedProduct(productId);
      if (success) {
        log('SavedProductCubit: Product removed successfully');

        // Show success message
        emit(SavedProductSuccess(message: 'Product removed from saved items'));

        // Fetch all saved products again to refresh the list
        await fetchSavedProductsWithDetails();
      } else {
        log('SavedProductCubit: Failed to remove saved product');
        emit(SavedProductError(message: 'Failed to remove saved product'));
      }
    } catch (e) {
      log('SavedProductCubit: Error removing saved product: $e');
      emit(SavedProductError(message: e.toString()));
    }
  }

  Future<void> fetchSavedProducts() async {
    emit(SavedProductLoading());
    log('SavedProductCubit: Fetching saved products');
    try {
      final savedProducts = await _repository.getSavedProducts();
      log('SavedProductCubit: Fetched ${savedProducts.length} saved products');
      if (savedProducts.isEmpty) {
        log('SavedProductCubit: No saved products found');
        emit(SavedProductsEmpty());
      } else {
        emit(SavedProductsLoaded(savedProducts: savedProducts));
      }
    } catch (e) {
      log('SavedProductCubit: Error fetching saved products: $e');
      emit(SavedProductError(message: e.toString()));
    }
  }

  Future<void> fetchSavedProductsWithDetails() async {
    emit(SavedProductLoading());
    log('SavedProductCubit: Fetching saved products with details');
    try {
      final productDetails = await _repository.getSavedProductsWithDetails();
      log('SavedProductCubit: Fetched ${productDetails.length} saved products with details');
      if (productDetails.isEmpty) {
        log('SavedProductCubit: No saved products with details found');
        emit(SavedProductsEmpty());
      } else {
        emit(SavedProductDetailsLoaded(productDetails: productDetails));
      }
    } catch (e) {
      log('SavedProductCubit: Error fetching saved products with details: $e');
      emit(SavedProductError(message: e.toString()));
    }
  }
}
