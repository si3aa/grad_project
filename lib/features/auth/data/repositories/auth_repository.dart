import 'package:Herfa/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:Herfa/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/login_response.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/models/user_model.dart';
import 'package:Herfa/features/auth/data/models/verify_response.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepository(this.remoteDataSource, this.localDataSource);

  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await remoteDataSource.register(request);
      if (response.success == true && response.user != null) {
        return response.user!;
      } else {
        throw Exception(response.message ?? 'Registration failed');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Failed to register: ${e.message}');
      }
      throw Exception('Failed to register: $e');
    }
  }

  Future<VerifyResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await remoteDataSource.verifyOTP(email, otp);
      return response;
    } catch (e) {
      if (e is DioException) {
        return VerifyResponse(
          success: false,
          message: 'Failed to verify OTP: ${e.message}',
        );
      }
      return VerifyResponse(
        success: false,
        message: 'Failed to verify OTP: $e',
      );
    }
  }

 Future<LoginResponse> login(LoginRequest request) async {
  try {
    final response = await remoteDataSource.login(request);
    if (response.success == true && response.token != null) {
      await localDataSource.saveToken(response.token!);
    }
    return response; 
  } catch (e) {
    if (e is DioException) {
      return LoginResponse(
        success: false,
        message: 'Failed to login: ${e.message}',
      );
    }
    return LoginResponse(
      success: false,
      message: 'Failed to login: $e',
    );
  }
}

}