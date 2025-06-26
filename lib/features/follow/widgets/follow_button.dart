import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final int ownerId;
  final int? currentUserId;

  const FollowButton({
    Key? key,
    required this.ownerId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null || currentUserId == ownerId) {
      return const SizedBox.shrink();
    }
    return TextButton(
      onPressed: () {
        print('Attempting to follow userId: $ownerId');
        // TODO: Add follow logic here
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Follow',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
