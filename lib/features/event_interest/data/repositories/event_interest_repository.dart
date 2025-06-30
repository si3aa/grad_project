import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class EventInterestRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource;
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  EventInterestRepository({
    required Dio dio,
    required AuthSharedPrefLocalDataSource authDataSource,
  })  : _dio = dio,
        _authDataSource = authDataSource;

  Future<bool> addInterest(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw Exception('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('$_baseUrl/events/$eventId/interest');
      
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      }
      throw Exception('Failed to add interest: ${e.message}');
    }
  }

  Future<bool> removeInterest(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw Exception('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.delete('$_baseUrl/events/$eventId/interest');
      
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      }
      throw Exception('Failed to remove interest: ${e.message}');
    }
  }

  Future<bool> getInterestStatus(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) {
        throw Exception('No authentication token found.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('$_baseUrl/events/$eventId/interest');
      
      return response.data['interested'] ?? false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid or expired token.');
      }
      return false; // Default to not interested if there's an error
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
