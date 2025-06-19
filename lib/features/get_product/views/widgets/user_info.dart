// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerUsername;
  final String userImage;
  final VoidCallback onMore;

  const UserInfo({
    super.key,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerUsername,
    required this.userImage,
    required this.onMore,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(widget.userImage),
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
                '${widget.ownerFirstName ?? ''} ${widget.ownerLastName ?? ''}'
                    .trim(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '@${widget.ownerUsername ?? ''}',
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
        // Follow button
        TextButton.icon(
          onPressed: () {
            setState(() {
              isFollowing = !isFollowing;
            });
            // Here you would typically call an API to follow/unfollow the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isFollowing
                    ? 'You are now following ${widget.ownerFirstName ?? widget.ownerUsername}'
                    : 'You unfollowed ${widget.ownerFirstName ?? widget.ownerUsername}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: Icon(
            isFollowing ? Icons.check : Icons.add,
            size: 16,
            color: isFollowing ? Colors.purpleAccent : Colors.blueGrey,
          ),
          label: Text(
            isFollowing ? 'Following' : 'Follow',
            style: TextStyle(
              color: isFollowing ? Colors.purpleAccent : Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: isFollowing
                ? Colors.green.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(
            Icons.more_horiz,
            semanticLabel: 'More options',
          ),
          onPressed: widget.onMore,
        ),
      ],
    );
  }
}
