part of 'follow_cubit.dart';

abstract class FollowState {
  final bool isFollowing;
  const FollowState(this.isFollowing);
}

class FollowInitial extends FollowState {
  const FollowInitial(bool isFollowing) : super(isFollowing);
}

class FollowLoading extends FollowState {
  const FollowLoading(bool isFollowing) : super(isFollowing);
}

class FollowSuccess extends FollowState {
  const FollowSuccess(bool isFollowing) : super(isFollowing);
}

class FollowError extends FollowState {
  final String message;
  const FollowError(this.message, bool isFollowing) : super(isFollowing);
}
