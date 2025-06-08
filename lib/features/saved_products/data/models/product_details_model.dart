/// Model class for product details to be displayed in saved products screen
class ProductDetailsModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final double price;
  final double discountedPrice;
  final int discountPercentage;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String userId;
  final String userName;
  final String userImage;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  /// Calculate discount percentage based on original and discounted price
  int calculateDiscountPercentage() {
    // ignore: unnecessary_null_comparison
    if (discountedPrice == null || discountedPrice >= price) {
      return 0;
    }
    return ((price - discountedPrice) / price * 100).round();
  }

  /// Get the first image URL or a placeholder if no images are available
  String get mainImageUrl {
    if (images.isEmpty) {
      return 'assets/images/placeholder.png';
    }
    return images.first;
  }

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Safely convert ID to string regardless of its original type
    String id = '';
    if (json['productId'] != null) {
      id = json['productId'].toString();
    } else if (json['id'] != null) {
      id = json['id'].toString();
    }

    // Safely convert userId to string
    String userId = '';
    if (json['userId'] != null) {
      userId = json['userId'].toString();
    }

    return ProductDetailsModel(
      id: id,
      name: json['name']?.toString() ?? 'Unknown Product',
      title: json['shortDescription']?.toString() ?? '',
      description: json['longDescription']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountedPrice:
          double.tryParse(json['discountedPrice']?.toString() ?? '0') ?? 0.0,
      discountPercentage:
          int.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: int.tryParse(json['reviewCount']?.toString() ?? '0') ?? 0,
      images: json['media'] != null
          ? [json['media'].toString()]
          : ['assets/images/product_1.png'],
      userId: userId,
      userName: json['userName']?.toString() ?? 'Unknown Seller',
      userImage: json['userImage']?.toString() ?? 'assets/images/user.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'images': images,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
    };
  }
}
