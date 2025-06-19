import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../user/viewmodel/user_viewmodel.dart';

class UserInfoNew extends StatefulWidget {
  final String userName;
  final String userHandle;
  final String userImage;
  final VoidCallback onMore;

  const UserInfoNew({
    super.key,
    required this.userName,
    required this.userHandle,
    required this.userImage,
    required this.onMore,
  });

  @override
  State<UserInfoNew> createState() => _UserInfoNewState();
}

class _UserInfoNewState extends State<UserInfoNew> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final displayName = userViewModel.fullName.isNotEmpty ? userViewModel.fullName : widget.userName;
    final displayUsername = userViewModel.username.isNotEmpty ? userViewModel.username : widget.userHandle;

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
                displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                "@$displayUsername",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: widget.onMore,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isFollowing = !isFollowing;
            });
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: isFollowing ? Colors.grey[200] : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            isFollowing ? 'Following' : 'Follow',
            style: TextStyle(
              color: isFollowing ? Colors.black87 : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
