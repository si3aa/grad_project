class ProductModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final bool isActive;
  final List<String> colors;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    this.isActive = true,
    required this.colors,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'isActive': isActive,
      'colors': colors,
      'images': images,
    };
  }
}

// API response model
class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

