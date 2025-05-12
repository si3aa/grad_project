class ProductModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String category;
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
    required this.category,
    required this.categoryId,
    required this.isActive,
    required this.colors,
    required this.images,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      category: json['category'],
      categoryId: json['categoryId'] ?? 0,
      isActive: json['isActive'],
      colors: List<String>.from(json['colors']),
      images: List<String>.from(json['images']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
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
}



