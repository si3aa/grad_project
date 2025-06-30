import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;

  const NotificationItemWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(notification.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: notification.category == NotificationCategory.recommended
                            // ignore: deprecated_member_use
                            ? Colors.orange.withOpacity(0.2)
                            // ignore: deprecated_member_use
                            : kPrimaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        notification.category == NotificationCategory.recommended
                            ? "Recommended"
                            : "General",
                        style: TextStyle(
                          color: notification.category == NotificationCategory.recommended
                              ? Colors.orange
                              : kPrimaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.timeAgo,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}