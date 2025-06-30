import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowCubit extends Cubit<bool> {
  final String userId;
  static String _key(String userId) => 'followed_$userId';

  FollowCubit({required this.userId}) : super(false) {
    _loadFollowState();
  }

  Future<void> _loadFollowState() async {
    final prefs = await SharedPreferences.getInstance();
    final isFollowing = prefs.getBool(_key(userId)) ?? false;
    emit(isFollowing);
  }

  Future<void> toggleFollow() async {
    final prefs = await SharedPreferences.getInstance();
    final newState = !state;
    await prefs.setBool(_key(userId), newState);
    emit(newState);
  }

  Future<void> setFollow(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(userId), value);
    emit(value);
  }
}
