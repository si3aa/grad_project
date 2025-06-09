class CommentModel {
  final int id;
  final String content;
  final String createdAt;
  final String? userName;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.userName,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userName: json['userName'] ?? '',
    );
  }
}
