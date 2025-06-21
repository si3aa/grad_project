import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/auth/data/data_source/remote/auth_api_remote_data_source.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/repositories/auth_repository.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  late final AuthRepository repository;
  final UserViewModel userViewModel;

  AuthCubit({required this.userViewModel}) : super(AuthInitial()) {
    repository = AuthRepository(
      AuthApiRemoteDataSource(),
      AuthSharedPrefLocalDataSource(),
    );
  }

  Future<void> register(RegisterRequest request) async {
    emit(AuthLoading());
    try {
      await repository.register(request);
      emit(AuthSuccess());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(AuthLoading());
    try {
      await repository.verifyOtp(email, otp);
      emit(AuthSuccess());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(LoginRequest request) async {
    emit(AuthLoading());
    try {
      final response = await repository.login(request);
      developer.log('Full login response: ${response.toJson()}',
          name: 'AuthCubit');

      if (response.success == true && response.token != null) {
        // After successful login, fetch and print user data
        try {
          await userViewModel.getCurrentUser();
          developer.log('Successfully fetched user data after login', name: 'AuthCubit');
        } catch (e) {
          developer.log('Error fetching user data after login: $e', 
            name: 'AuthCubit', error: e);
        }
        emit(AuthSuccess());
      } else if (response.message?.contains('email is not verified') == true) {
        emit(AuthError(
            'Please verify your email first. Check your inbox for the verification code.'));
      } else {
        emit(AuthError(response.message ?? 'Login failed'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
