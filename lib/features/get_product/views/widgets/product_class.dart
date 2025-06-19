class Product {
  final int id;
  final String userName;
  final String userHandle;
  final String userImage;
  final String productImage;
  final String productName;
  final double originalPrice;
  final double discountedPrice;
  
  final String title;
  final String description;
  final int quantity;

  Product({
    required this.userName,
    required this.userHandle,
    required this.userImage,
    required this.productImage,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
   
    required this.title,
    required this.description,
    required this.quantity,
    this.id = 0, // Default value for backward compatibility
  });
}
