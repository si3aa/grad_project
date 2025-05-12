import 'package:Herfa/core/constant.dart';
import 'package:Herfa/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/login_response.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/models/register_response.dart';
import 'package:Herfa/features/auth/data/models/verify_response.dart';
import 'package:dio/dio.dart';

class AuthApiRemoteDataSource extends AuthRemoteDataSource {
  final Dio _dio;

  AuthApiRemoteDataSource() : _dio = Dio() {
    _dio.options.baseUrl = APIConstants.baseURL;
    _dio.options.validateStatus = (status) => true;
  }
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        APIConstants.loginEndPoint,
        data: request.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        APIConstants.registerEndPoint,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register: ${response.statusMessage}');
      }
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
Future<VerifyResponse> verifyOTP(String email, String otp) async {
  try {
    final response = await _dio.post(
      APIConstants.verifyOtpEndPoint,
      queryParameters: {
        'email': email,
        'otp': otp,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP: ${response.statusMessage}');
    }

    return VerifyResponse.fromJson(response.data);
  } catch (e) {
    throw Exception('Failed to verify OTP: $e');
  }
}

}
