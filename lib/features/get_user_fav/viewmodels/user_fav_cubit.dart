import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/user_fav_model.dart';
import '../data/repository/user_fav_repository.dart';

// States
abstract class UserFavState extends Equatable {
  const UserFavState();

  @override
  List<Object> get props => [];
}

class UserFavInitial extends UserFavState {}

class UserFavLoading extends UserFavState {}

class UserFavLoaded extends UserFavState {
  final List<UserFavModel> users;

  const UserFavLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserFavError extends UserFavState {
  final String message;

  const UserFavError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class UserFavCubit extends Cubit<UserFavState> {
  final UserFavRepository _repository;

  UserFavCubit({UserFavRepository? repository})
      : _repository = repository ?? UserFavRepository(),
        super(UserFavInitial());

  Future<void> getUsersWhoFavoritedProduct(String productId) async {
    try {
      emit(UserFavLoading());

      final users = await _repository.getUsersWhoFavoritedProduct(productId);
      emit(UserFavLoaded(users));
    } catch (e) {
      emit(UserFavError(e.toString()));
    }
  }

  void reset() {
    emit(UserFavInitial());
  }
}
