import '../../data/models/saved_product_model.dart';
import '../../data/models/product_details_model.dart';

abstract class SavedProductState {
  const SavedProductState();
}

class SavedProductInitial extends SavedProductState {}

class SavedProductLoading extends SavedProductState {}

class SavedProductSuccess extends SavedProductState {
  final String message;

  SavedProductSuccess({required this.message});
}

class SavedProductError extends SavedProductState {
  final String message;

  SavedProductError({required this.message});
}

class SavedProductsLoaded extends SavedProductState {
  final List<SavedProductModel> savedProducts;

  SavedProductsLoaded({required this.savedProducts});
}

class SavedProductDetailsLoaded extends SavedProductState {
  final List<ProductDetailsModel> productDetails;

  SavedProductDetailsLoaded({required this.productDetails});
}

class SavedProductsEmpty extends SavedProductState {
  @override
  // ignore: override_on_non_overriding_member
  List<Object?> get props => [];
}
