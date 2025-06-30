
import 'package:Herfa/core/services/fcm_services.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/auth/data/data_source/remote/auth_api_remote_data_source.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/features/auth/data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final AuthRepository repository;
  late final AuthSharedPrefLocalDataSource _localDataSource;

  AuthCubit() : super(AuthInitial()) {
    _localDataSource = AuthSharedPrefLocalDataSource();
    repository = AuthRepository(
      AuthApiRemoteDataSource(),
      _localDataSource,
    );
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _localDataSource.getToken();
    if (token != null) {
      emit(AuthLoggedIn(token));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> register(RegisterRequest request) async {
    emit(AuthLoading());
    try {
      final user = await repository.register(request);
      // Store userId from registration response
      if (user.id != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user.id!);
        print('Stored userId after registration: [1m${user.id!}[22m');
      }
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
      final fcmToken = await FCMServices().getFCMToken();
      final response = await repository.login(request);
      developer.log('Full login response: ${response.toJson()}',
          name: 'AuthCubit');
      developer.log('FCM Token: $fcmToken', name: 'AuthCubit');
      if (response.success == true && response.token != null) {
        await _localDataSource.saveToken(response.token!);

        // Fetch user info and store userId
        final user = await repository.fetchCurrentUser(response.token!);
        if (user != null && user.id != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', user.id!);
          print('Stored userId after login: [1m${user.id!}[22m');
        }

        emit(AuthLoggedIn(response.token!));
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

  Future<void> logout() async {
    await _localDataSource.saveToken('');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    emit(AuthInitial());
  }
}
