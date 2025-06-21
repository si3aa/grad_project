class EventCommentModel {
  final int id;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final String? userFirstName;
  final String? userLastName;
  final int? userId;
  final String? eventId;

  EventCommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.userFirstName,
    this.userLastName,
    this.userId,
    this.eventId,
  });

  factory EventCommentModel.fromJson(Map<String, dynamic> json) {
    return EventCommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      userFirstName: json['userFirstName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      userId: json['userId'],
      eventId: json['eventId']?.toString(),
    );
  }
}
