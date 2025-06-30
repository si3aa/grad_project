import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/get_me/me_repository.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

abstract class CurrentUserState {}

class CurrentUserInitial extends CurrentUserState {}

class CurrentUserLoading extends CurrentUserState {}

class CurrentUserLoaded extends CurrentUserState {
  final Data user;
  CurrentUserLoaded(this.user);
}

class CurrentUserError extends CurrentUserState {
  final String message;
  CurrentUserError(this.message);
}

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final MeRepository meRepository;
  CurrentUserCubit(this.meRepository) : super(CurrentUserInitial());

  Future<void> fetchCurrentUser() async {
    emit(CurrentUserLoading());
    try {
      final user = await meRepository.getMe();
      if (user != null) {
        emit(CurrentUserLoaded(user));
      } else {
        emit(CurrentUserError('Failed to fetch user info'));
      }
    } catch (e) {
      emit(CurrentUserError(e.toString()));
    }
  }
}
