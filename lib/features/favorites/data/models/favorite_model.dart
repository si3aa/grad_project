class FavoriteModel {
  final String id;
  final String productId;
  final String createdAt;

  FavoriteModel({
    required this.id,
    required this.productId,
    required this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'created_at': createdAt,
    };
  }
}
