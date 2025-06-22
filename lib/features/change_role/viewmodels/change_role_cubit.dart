import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/change_role_repository.dart';

abstract class ChangeRoleState {}

class ChangeRoleInitial extends ChangeRoleState {}

class ChangeRoleLoading extends ChangeRoleState {}

class ChangeRoleSuccess extends ChangeRoleState {
  final Map<String, dynamic> response;
  ChangeRoleSuccess(this.response);
}

class ChangeRoleError extends ChangeRoleState {
  final String message;
  ChangeRoleError(this.message);
}

class ChangeRoleCubit extends Cubit<ChangeRoleState> {
  final ChangeRoleRepository repository;
  ChangeRoleCubit(this.repository) : super(ChangeRoleInitial());

  Future<void> changeRole(String username, String password) async {
    emit(ChangeRoleLoading());
    try {
      final response = await repository.changeRole(username, password);
      emit(ChangeRoleSuccess(response));
    } catch (e) {
      emit(ChangeRoleError(e.toString()));
    }
  }
}
