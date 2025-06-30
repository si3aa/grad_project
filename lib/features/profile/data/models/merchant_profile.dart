class MerchantProfile {
  final int userId;
  final String firstName;
  final String lastName;
  final String bio;
  final String phone;
  final String address;
  final String? profilePictureUrl;
  final double averageRating;
  final int numberOfRatings;
  final List<ProductMerchant> products;

  MerchantProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.phone,
    required this.address,
    this.profilePictureUrl,
    required this.averageRating,
    required this.numberOfRatings,
    required this.products,
  });

  factory MerchantProfile.fromJson(Map<String, dynamic> json) =>
      MerchantProfile(
        userId: json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        bio: json['bio'],
        phone: json['phone'],
        address: json['address'],
        profilePictureUrl: json['profilePictureUrl'],
        averageRating: (json['averageRating'] ?? 0).toDouble(),
        numberOfRatings: json['numberOfRatings'] ?? 0,
        products: (json['products'] as List)
            .map((e) => ProductMerchant.fromJson(e))
            .toList(),
      );
}

class ProductMerchant {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int quantity;
  final String media;
  final bool active;
  final List<String> colors;
  final double discountedPrice;

  ProductMerchant({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.quantity,
    required this.media,
    required this.active,
    required this.colors,
    required this.discountedPrice,
  });

  factory ProductMerchant.fromJson(Map<String, dynamic> json) =>
      ProductMerchant(
        id: json['id'],
        name: json['name'],
        shortDescription: json['shortDescription'],
        longDescription: json['longDescription'],
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'],
        media: json['media'],
        active: json['active'],
        colors: List<String>.from(json['colors']),
        discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      );
}

class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String bio;
  final String? profilePictureUrl;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.bio,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        address: json['address'],
        bio: json['bio'],
        profilePictureUrl: json['profilePictureUrl'],
      );
}
