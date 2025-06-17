import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String imageUrl;
  final String organizerId;
  final bool isActive;
  final List<String> attendees;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    required this.organizerId,
    this.isActive = true,
    this.attendees = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      organizerId: json['organizerId'] as String,
      isActive: json['isActive'] ?? true,
      attendees: List<String>.from(json['attendees'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title, // API expects 'name' not 'title'
      'description': description,
      'startTime': startDate.toIso8601String(), // API expects 'startTime'
      'endTime': endDate.toIso8601String(), // API expects 'endTime'
      'price': price,
      'media': imageUrl, // API expects 'media' not 'imageUrl'
    };
  }

  // Keep the original toJson for internal use if needed
  Map<String, dynamic> toJsonInternal() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'price': price,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'isActive': isActive,
      'attendees': attendees,
    };
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        price,
        imageUrl,
        organizerId,
        isActive,
        attendees,
      ];

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? price,
    String? imageUrl,
    String? organizerId,
    bool? isActive,
    List<String>? attendees,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerId: organizerId ?? this.organizerId,
      isActive: isActive ?? this.isActive,
      attendees: attendees ?? this.attendees,
    );
  }
}
