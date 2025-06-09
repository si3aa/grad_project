class CommentModel {
  final int id;
  final String content;
  final String createdAt;
  final String? userName;
  final String? productId;
  final String? productName;
  final String? productImage;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.userName,
    this.productId,
    this.productName,
    this.productImage,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userName: json['userName'] ?? '',
      productId: json['productId']?.toString(),
      productName: json['productName'],
      productImage: json['productImage'],
    );
  }

  // Create a copy with additional product information
  CommentModel copyWithProductInfo({
    String? productId,
    String? productName,
    String? productImage,
  }) {
    return CommentModel(
      id: id,
      content: content,
      createdAt: createdAt,
      userName: userName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
    );
  }
}
