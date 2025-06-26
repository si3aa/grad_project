class AllproductDataModel {
  int? id;
  int? userId;
  String? name;
  String? shortDescription;
  String? longDescription;
  double? price;
  int? quantity;
  String? media;
  bool? active;
  List<String>? colors;
  double? discountedPrice;
  String? userUsername;
  String? userFirstName;
  String? userLastName;
  int likes = 0;
  int comments = 0;

  AllproductDataModel(
      {this.id,
      this.userId,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.price,
      this.quantity,
      this.media,
      this.active,
      this.colors,
      this.discountedPrice,
      this.userUsername,
      this.userFirstName,
      this.userLastName,
      this.likes = 0,
      this.comments = 0});

  AllproductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    userId = json['userId'] is String
        ? int.tryParse(json['userId'])
        : json['userId'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    longDescription = json['longDescription'];
    price = json['price'] is String
        ? double.tryParse(json['price'])
        : json['price']?.toDouble();
    quantity = json['quantity'] is String
        ? int.tryParse(json['quantity'])
        : json['quantity'];
    media = json['media'];
    active = json['active'];
    colors = json['colors'] != null ? List<String>.from(json['colors']) : [];
    userUsername = json['userUsername'];
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];

    // Handle discountedPrice as double
    if (json['discountedPrice'] != null) {
      if (json['discountedPrice'] is String) {
        discountedPrice = double.tryParse(json['discountedPrice']);
      } else if (json['discountedPrice'] is int) {
        discountedPrice = (json['discountedPrice'] as int).toDouble();
      } else {
        discountedPrice = json['discountedPrice'];
      }
    }

    likes = json['likes'] ?? 0;
    comments = json['comments'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['longDescription'] = this.longDescription;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['media'] = this.media;
    data['active'] = this.active;
    data['colors'] = this.colors;
    data['discountedPrice'] = this.discountedPrice;
    data['userUsername'] = this.userUsername;
    data['userFirstName'] = this.userFirstName;
    data['userLastName'] = this.userLastName;
    return data;
  }

  // Helper method to get formatted user name
  String get userFullName {
    String firstName = userFirstName?.trim() ?? '';
    String lastName = userLastName?.trim() ?? '';
    // Capitalize first letter of last name
    if (lastName.isNotEmpty) {
      lastName =
          lastName[0].toUpperCase() + lastName.substring(1).toLowerCase();
    }
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return userUsername ?? 'Anonymous';
  }
}
