part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}

class AuthLoggedIn extends AuthState {
  final String token;
  AuthLoggedIn(this.token);
}

class AuthLoggedInWithUser extends AuthState {
  final String token;
  final UserModel user;
  AuthLoggedInWithUser(this.token, this.user);
}
