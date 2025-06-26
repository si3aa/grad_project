import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/follow_repository.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final FollowRepository repository;
  bool isFollowing;
  FollowCubit(this.repository, {this.isFollowing = false})
      : super(FollowInitial(isFollowing));

  Future<void> initFollowState(int ownerId) async {
    emit(FollowLoading(isFollowing));
    try {
      final followings = await repository.getFollowings();
      isFollowing = followings.contains(ownerId);
      emit(FollowInitial(isFollowing));
    } catch (e) {
      emit(FollowError(e.toString(), isFollowing));
    }
  }

  Future<void> followUser(int userId) async {
    emit(FollowLoading(isFollowing));
    try {
      await repository.followUser(userId);
      isFollowing = true;
      emit(FollowSuccess(isFollowing));
    } catch (e) {
      emit(FollowError(e.toString(), isFollowing));
    }
  }

  Future<void> unfollowUser(int userId) async {
    emit(FollowLoading(isFollowing));
    try {
      await repository.unfollowUser(userId);
      isFollowing = false;
      emit(FollowSuccess(isFollowing));
    } catch (e) {
      emit(FollowError(e.toString(), isFollowing));
    }
  }

  void toggleFollow(int userId) {
    if (isFollowing) {
      unfollowUser(userId);
    } else {
      followUser(userId);
    }
  }
}
