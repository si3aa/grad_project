class SavedProductModel {
  final String id;
  final String productId;
  final String userId;
  final DateTime savedAt;

  SavedProductModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.savedAt,
  });

  factory SavedProductModel.fromJson(Map<String, dynamic> json) {
    return SavedProductModel(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}