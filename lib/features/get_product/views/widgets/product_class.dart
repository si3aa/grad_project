class Product {
  final int id;
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerUsername;
  final String userImage;
  final String productImage;
  final String productName;
  final double originalPrice;
  final double discountedPrice;
  int likes;
  int comments;
  final String title;
  final String description;
  final int quantity;

  Product({
    required this.id,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerUsername,
    required this.userImage,
    required this.productImage,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.likes,
    required this.comments,
    required this.title,
    required this.description,
    required this.quantity,
  });
}
