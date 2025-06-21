class CommentModel {
  final int id;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final String userFirstName;
  final String userLastName;
  final int userId;
  final int productId;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.userFirstName,
    required this.userLastName,
    required this.userId,
    required this.productId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      userFirstName: json['userFirstName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      userId: json['userId'] ?? 0,
      productId: json['productId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userId': userId,
      'productId': productId,
    };
  }
}
