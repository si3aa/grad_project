class Product {
  final String userName;
  final String userHandle;
  final String userImage;
  final String productImage;
  final String productName;
  final double originalPrice;
  final double discountedPrice;
  int likes; 
  int comments; 
  final String description;
  final int quantity;
  final String title;

  Product( {
    required this.userName,
    required this.userHandle,
    required this.userImage,
    required this.productImage,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.likes,
    required this.comments,
    required this.description,
    required this.quantity,
    required this.title,
  });
}
