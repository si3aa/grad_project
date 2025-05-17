class AllproductDataModel {
  int? id;
  String? name;
  String? shortDescription;
  String? longDescription;
  double? price;
  int? quantity;
  String? media;
  bool? active;
  List<String>? colors;
  double? discountedPrice; // Changed from int? to double?
  int likes = 0;
  int comments = 0;

  AllproductDataModel({
      this.id,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.price,
      this.quantity,
      this.media,
      this.active,
      this.colors,
      this.discountedPrice,
      this.likes = 0,
      this.comments = 0});

  AllproductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    longDescription = json['longDescription'];
    price = json['price'] is String ? double.tryParse(json['price']) : json['price']?.toDouble();
    quantity = json['quantity'] is String ? int.tryParse(json['quantity']) : json['quantity'];
    media = json['media'];
    active = json['active'];
    colors = json['colors'] != null ? List<String>.from(json['colors']) : [];
    
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
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['longDescription'] = this.longDescription;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['media'] = this.media;
    data['active'] = this.active;
    data['colors'] = this.colors;
    data['discountedPrice'] = this.discountedPrice;
    return data;
  }
}
