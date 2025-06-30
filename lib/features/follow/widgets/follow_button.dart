import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../follow_cubit.dart';

class FollowButton extends StatelessWidget {
  final String userId;
  final void Function(bool isFollowing)? onChanged;

  const FollowButton({
    Key? key,
    required this.userId,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowCubit>(
      create: (_) => FollowCubit(userId: userId),
      child: BlocBuilder<FollowCubit, bool>(
        builder: (context, isFollowing) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              context.read<FollowCubit>().toggleFollow();
              if (onChanged != null)
                onChanged!(context.read<FollowCubit>().state);
            },
            child: Text(isFollowing ? 'Following' : 'Follow'),
          );
        },
      ),
    );
  }
}
