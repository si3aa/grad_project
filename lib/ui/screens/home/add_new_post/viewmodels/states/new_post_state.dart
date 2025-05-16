import 'package:equatable/equatable.dart';

class NewPostState extends Equatable {
  final List<String> images;
  final String productName;
  final String productTitle;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final List<String> selectedColorNames;
  final String error;
  final bool isLoading;
  final bool isActive;

  NewPostState({
    this.images = const [],
    this.productName = '',
    this.productTitle = '',
    this.description = '',
    this.price = 0.0,
    this.quantity = 0,
    this.categoryId = 0,
    this.selectedColorNames = const [],
    this.error = '',
    this.isLoading = false,
    this.isActive = false,
  });

  NewPostState copyWith({
    List<String>? images,
    String? productName,
    String? productTitle,
    String? description,
    double? price,
    int? quantity,
    int? categoryId,
    List<String>? selectedColorNames,
    String? error,
    bool? isLoading,
    bool? isActive,
  }) {
    return NewPostState(
      images: images ?? this.images,
      productName: productName ?? this.productName,
      productTitle: productTitle ?? this.productTitle,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categoryId: categoryId ?? this.categoryId,
      selectedColorNames: selectedColorNames ?? this.selectedColorNames,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        images,
        productName,
        productTitle,
        description,
        price,
        quantity,
        categoryId,
        selectedColorNames,
        error,
        isLoading,
        isActive,
      ];
}