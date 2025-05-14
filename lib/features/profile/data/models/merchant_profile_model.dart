class MerchantProfileModel {
  final int userId;
  final String firstName;
  final String lastName;
  final String bio;
  final String phone;
  final String address;
  final String? profilePictureUrl;
  final double averageRating;
  final int numberOfRatings;
  final List<dynamic> products;

  MerchantProfileModel({
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

  factory MerchantProfileModel.fromJson(Map<String, dynamic> json) =>
      MerchantProfileModel(
        userId: json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        bio: json['bio'],
        phone: json['phone'],
        address: json['address'],
        profilePictureUrl: json['profilePictureUrl'],
        averageRating: (json['averageRating'] as num).toDouble(),
        numberOfRatings: json['numberOfRatings'],
        products: json['products'] ?? [],
      );
}
