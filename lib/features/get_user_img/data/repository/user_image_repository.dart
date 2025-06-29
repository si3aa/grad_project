import 'dart:developer' as developer;
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user_image_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class UserImageRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  UserImageRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<UserImageModel> getUserImage(int userId) async {
    try {
      final token = await _authDataSource.getToken();
      final url = '$_baseUrl/profiles/image/user/3';

      // Log request details
      developer.log('=== USER IMAGE API REQUEST ===', name: 'UserImageAPI');
      developer.log('URL: $url', name: 'UserImageAPI');
      developer.log('Method: GET', name: 'UserImageAPI');
      developer.log('User ID: $userId', name: 'UserImageAPI');
      developer.log(
          'Token: ${token != null ? 'Bearer ${token.substring(0, 20)}...' : 'null'}',
          name: 'UserImageAPI');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      developer.log('Headers: ${jsonEncode(headers)}', name: 'UserImageAPI');
      developer.log('================================', name: 'UserImageAPI');

      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );

      // Log response details
      developer.log('=== USER IMAGE API RESPONSE ===', name: 'UserImageAPI');
      developer.log('Status Code: ${response.statusCode}',
          name: 'UserImageAPI');
      developer.log('Status Message: ${response.statusMessage}',
          name: 'UserImageAPI');
      developer.log('Response Headers: ${jsonEncode(response.headers.map)}',
          name: 'UserImageAPI');
      developer.log('Response Data: ${jsonEncode(response.data)}',
          name: 'UserImageAPI');
      developer.log('================================', name: 'UserImageAPI');

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true) {
        final userImage = UserImageModel.fromJson(response.data);
        developer.log('Successfully parsed user image: ${userImage.imageUrl}',
            name: 'UserImageAPI');
        return userImage;
      }

      developer.log('API call failed - Invalid response structure',
          name: 'UserImageAPI');
      throw Exception('Failed to get user image - Invalid response');
    } catch (e) {
      developer.log('=== USER IMAGE API ERROR ===', name: 'UserImageAPI');
      developer.log('Error Type: ${e.runtimeType}', name: 'UserImageAPI');
      developer.log('Error Message: $e', name: 'UserImageAPI');

      if (e is DioException) {
        developer.log('Dio Error Type: ${e.type}', name: 'UserImageAPI');
        developer.log('Dio Error Response: ${e.response?.data}',
            name: 'UserImageAPI');
        developer.log('Dio Error Status Code: ${e.response?.statusCode}',
            name: 'UserImageAPI');
      }

      developer.log('============================', name: 'UserImageAPI');
      throw Exception('Failed to get user image: $e');
    }
  }
}
