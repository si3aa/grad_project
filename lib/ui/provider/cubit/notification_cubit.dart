import 'package:flutter_bloc/flutter_bloc.dart';

enum NotificationCategory { general, recommended }

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void fetchNotifications() {
    final notifications = [
      NotificationItem(
        id: 1,
        title: "SALE IS LIVE",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        category: NotificationCategory.recommended,
        timeAgo: "1m ago",
        imageUrl: "assets/images/small_notif.png",
      ),
      NotificationItem(
        id: 2,
        title: "SALE IS LIVE",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        category: NotificationCategory.recommended,
        timeAgo: "1m ago",
        imageUrl: "assets/images/small_notif.png",
      ),
      NotificationItem(
        id: 3,
        title: "SALE IS LIVE",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        category: NotificationCategory.recommended,
        timeAgo: "10 Hrs ago",
        imageUrl: "assets/images/small_notif.png",
      ),
      NotificationItem(
        id: 4,
        title: "SALE IS LIVE",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        category: NotificationCategory.recommended,
        timeAgo: "15 Hrs ago",
        imageUrl: "assets/images/small_notif.png",
      ),
    ];
    emit(NotificationLoaded(notifications: notifications, selectedCategory: null));
  }

  void filterByCategory(NotificationCategory? category) {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final filteredNotifications = category == null
          ? currentState.notifications
          : currentState.notifications
              .where((n) => n.category == category)
              .toList();
      emit(NotificationLoaded(
          notifications: currentState.notifications,
          selectedCategory: category,
          filteredNotifications: filteredNotifications));
    }
  }
}

class NotificationState {
  final List<NotificationItem>? notifications;
  final NotificationCategory? selectedCategory;
  final List<NotificationItem>? filteredNotifications;

  NotificationState({
    this.notifications,
    this.selectedCategory,
    this.filteredNotifications,
  });
}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  NotificationLoaded({
    required this.notifications,
    this.selectedCategory,
    this.filteredNotifications,
  }) : super(
          notifications: notifications,
          selectedCategory: selectedCategory,
          filteredNotifications: filteredNotifications ?? notifications,
        );

  final List<NotificationItem> notifications;
  final NotificationCategory? selectedCategory;
  final List<NotificationItem>? filteredNotifications;
}

class NotificationItem {
  final int id;
  final String title;
  final String description;
  final NotificationCategory category;
  final String timeAgo;
  final String imageUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timeAgo,
    required this.imageUrl,
  });
}