class Product {
  final int id;
  final int userId;
  final String userFirstName;
  final String userUsername;
  final String userLastName;
  final String userImage;
  final String productImage;
  final String productName;
  final double originalPrice;
  final double discountedPrice;
  final String title;
  final String description;
  final int quantity;

  Product({
    required this.userId,
    required this.userFirstName,
    required this.userUsername,
    required this.userImage,
    required this.productImage,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.title,
    required this.description,
    required this.quantity,
    this.id = 0,
    required this.userLastName,
  });
}
