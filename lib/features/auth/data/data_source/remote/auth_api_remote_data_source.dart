import 'package:Herfa/core/constant.dart';
import 'package:Herfa/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/login_response.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/models/register_response.dart';
import 'package:Herfa/features/auth/data/models/verify_response.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class AuthApiRemoteDataSource extends AuthRemoteDataSource {
  final Dio _dio;

  AuthApiRemoteDataSource() : _dio = Dio() {
    _dio.options.baseUrl = APIConstants.baseURL;
    _dio.options.validateStatus = (status) => true;
  }
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final requestData = request.toJson();
      developer.log('Login request data: $requestData', name: 'AuthAPI');
      developer.log(
          'Login URL: ${APIConstants.baseURL}${APIConstants.loginEndPoint}',
          name: 'AuthAPI');

      final response = await _dio.post(
        APIConstants.loginEndPoint,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => true,
          followRedirects: false,
        ),
      );

      developer.log('Login response status: ${response.statusCode}',
          name: 'AuthAPI');
      developer.log('Login response data: ${response.data}', name: 'AuthAPI');
      developer.log('Login response headers: ${response.headers}',
          name: 'AuthAPI');

      if (response.statusCode != 200) {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? response.statusMessage
            : response.statusMessage;
        developer.log('Login error details: $errorMessage', name: 'AuthAPI');
        throw Exception('Failed to login: $errorMessage');
      }

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.token != null) {
        print('=== Login Token ===');
        print('Token: ${loginResponse.token}');
        print('==================');
      }

      return loginResponse;
    } catch (e) {
      developer.log('Login error: $e', name: 'AuthAPI');
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'AuthAPI');
        developer.log('Dio error message: ${e.message}', name: 'AuthAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'AuthAPI');
        }
      }
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
      developer.log('Verify OTP request - Email: $email, OTP: $otp',
          name: 'AuthAPI');
      developer.log(
          'Verify OTP URL: ${APIConstants.baseURL}${APIConstants.verifyOtpEndPoint}?email=$email&otp=$otp',
          name: 'AuthAPI');

      final response = await _dio.post(
        APIConstants.verifyOtpEndPoint,
        queryParameters: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      developer.log('Verify OTP response status: ${response.statusCode}',
          name: 'AuthAPI');
      developer.log('Verify OTP response data: ${response.data}',
          name: 'AuthAPI');

      if (response.statusCode != 200) {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? response.statusMessage
            : response.statusMessage;
        developer.log('Verify OTP error details: $errorMessage',
            name: 'AuthAPI');
        throw Exception('Failed to verify OTP: $errorMessage');
      }

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      return VerifyResponse.fromJson(response.data);
    } catch (e) {
      developer.log('Verify OTP error: $e', name: 'AuthAPI');
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'AuthAPI');
        developer.log('Dio error message: ${e.message}', name: 'AuthAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'AuthAPI');
        }
      }
      throw Exception('Failed to verify OTP: $e');
    }
  }
}
