import 'package:flutter/material.dart';
import 'package:Herfa/ui/screens/home/add_new_post/models/post_model.dart';
import 'package:Herfa/ui/screens/home/prduct/models/product_repository.dart';

class NewPostState {
  final List<String> images;
  final String productName;
  final String productTitle;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final int categoryId;
  final bool isActive;
  final List<Color> selectedColors;
  final bool isLoading;
  final String? error;

  NewPostState({
    this.images = const [],
    this.productName = '',
    this.productTitle = '',
    this.description = '',
    this.price = 0.0,
    this.quantity = 0,
    this.category = '',
    this.categoryId = 0,
    this.isActive = false,
    this.selectedColors = const [],
    this.isLoading = false,
    this.error,
  });

  NewPostState copyWith({
    List<String>? images,
    String? productName,
    String? productTitle,
    String? description,
    double? price,
    int? quantity,
    String? category,
    int? categoryId,
    bool? isActive,
    List<Color>? selectedColors,
    bool? isLoading,
    String? error,
  }) {
    return NewPostState(
      images: images ?? this.images,
      productName: productName ?? this.productName,
      productTitle: productTitle ?? this.productTitle,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      selectedColors: selectedColors ?? this.selectedColors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NewPostViewModel extends ChangeNotifier {
  final ProductRepository? repository;
  NewPostState _state = NewPostState();

  NewPostViewModel([this.repository]);

  NewPostState get state => _state;

  void addImage(String imagePath) {
    final updatedImages = List<String>.from(_state.images);
    updatedImages.add(imagePath);
    _state = _state.copyWith(images: updatedImages);
    notifyListeners();
  }

  void deleteImage(String imagePath) {
    final updatedImages = List<String>.from(_state.images);
    updatedImages.remove(imagePath);
    _state = _state.copyWith(images: updatedImages);
    notifyListeners();
  }

  void updateProductName(String name) {
    _state = _state.copyWith(productName: name);
    notifyListeners();
  }

  void updateProductTitle(String title) {
    _state = _state.copyWith(productTitle: title);
    notifyListeners();
  }

  void updateDescription(String description) {
    _state = _state.copyWith(description: description);
    notifyListeners();
  }

  void updatePrice(double price) {
    _state = _state.copyWith(price: price);
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    _state = _state.copyWith(quantity: quantity);
    notifyListeners();
  }

  void updateCategory(String category, int categoryId) {
    _state = _state.copyWith(category: category, categoryId: categoryId);
    notifyListeners();
  }

  void toggleColor(Color color) {
    final updatedColors = List<Color>.from(_state.selectedColors);
    
    if (updatedColors.contains(color)) {
      updatedColors.remove(color);
    } else {
      updatedColors.add(color);
    }
    
    _state = _state.copyWith(selectedColors: updatedColors);
    notifyListeners();
  }

  Future<bool> submitProduct() async {
    // Validate required fields
    if (_state.images.isEmpty) {
      _state = _state.copyWith(
        error: 'Please add at least one product image'
      );
      notifyListeners();
      return false;
    }
    
    if (_state.productName.isEmpty || 
        _state.productTitle.isEmpty || 
        _state.description.isEmpty ||
        _state.price <= 0 ||
        _state.quantity <= 0 ||
        _state.category.isEmpty ||
        _state.categoryId <= 0 ||
        _state.selectedColors.isEmpty) {
      
      _state = _state.copyWith(
        error: 'Please fill all required fields and select at least one color'
      );
      notifyListeners();
      return false;
    }

    try {
      _state = _state.copyWith(isLoading: true, error: null);
      notifyListeners();

      if (repository != null) {
        // Convert colors to string representation for API
        final colorStrings = _state.selectedColors
            // ignore: deprecated_member_use
            .map((color) => '#${color.value.toRadixString(16).substring(2)}')
            .toList();
            
        final product = ProductModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _state.productName,
          title: _state.productTitle,
          description: _state.description,
          price: _state.price,
          quantity: _state.quantity,
          category: _state.category,
          categoryId: _state.categoryId, // Include the category ID
          isActive: false, // Always false as requested
          colors: colorStrings,
          images: _state.images,
        );
        
        await repository!.addProduct(product);
      }

      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = NewPostState();
    notifyListeners();
  }
}












