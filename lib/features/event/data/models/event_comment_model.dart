class EventCommentModel {
  final int id;
  final String content;
  final String createdAt;
  final String? userName;
  final String? eventId;

  EventCommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.userName,
    this.eventId,
  });

  factory EventCommentModel.fromJson(Map<String, dynamic> json) {
    return EventCommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? json['commentText'] ?? '',
      createdAt: json['createdAt'] ?? json['created_at'] ?? '',
      userName: json['userName'] ?? json['user']?['username'] ?? '',
      eventId: json['eventId']?.toString(),
    );
  }
}
