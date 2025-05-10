import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String userName;
  final String userHandle;
  final String userImage;
  final VoidCallback onMore;

  const UserInfo({
    super.key,
    required this.userName,
    required this.userHandle,
    required this.userImage,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(userImage),
          onBackgroundImageError: (exception, stackTrace) {
            return;
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                userHandle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.more_horiz,
            semanticLabel: 'More options',
          ),
          onPressed: onMore,
        ),
      ],
    );
  }
}