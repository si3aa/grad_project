import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/follow_cubit.dart';

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
    // Agent: Only show if not owner and not already following
    if (currentUserId == null || currentUserId == ownerId) {
      return const SizedBox.shrink();
    }
    return FutureBuilder(
      future: context.read<FollowCubit>().initFollowState(ownerId),
      builder: (context, snapshot) {
        return BlocBuilder<FollowCubit, FollowState>(
          builder: (context, state) {
            final isFollowing = state.isFollowing;
            if (state is FollowLoading ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox
                  .shrink(); // Hide while loading for agent behavior
            }
            if (isFollowing) {
              return const SizedBox.shrink(); // Hide if already following
            }
            return TextButton(
              onPressed: () =>
                  context.read<FollowCubit>().toggleFollow(ownerId),
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
          },
        );
      },
    );
  }
}
