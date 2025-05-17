
/// Represents a product with its details such as name, price, and availability.
class ProductModel {
  /// Unique identifier for the product
  final String id;

  /// Short name of the product
  final String name;

  /// Display title of the product
  final String title;

  /// Detailed description of the product
  final String description;

  /// Price of the product
  final double price;

  /// Available quantity in stock
  final int quantity;

  /// ID of the category this product belongs to
  final int categoryId;

  /// Indicates if the product is active for sale
  final bool isActive;

  /// List of available colors for the product
  final List<String> colors;

  /// List of image URLs for the product
  final List<String> images;

  /// Creates a [ProductModel] instance with the provided details.
  const ProductModel({
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

  /// Creates a [ProductModel] from a JSON map.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      categoryId: json['categoryId'] as int,
      isActive: json['isActive'] as bool? ?? true,
      colors: (json['colors'] as List<dynamic>).cast<String>(),
      images: (json['images'] as List<dynamic>).cast<String>(),
    );
  }

  /// Converts the [ProductModel] to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
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