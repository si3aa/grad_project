import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class GetInterEventRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource;
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  GetInterEventRepository({
    Dio? dio,
    AuthSharedPrefLocalDataSource? authDataSource,
  })  : _dio = dio ?? Dio(),
        _authDataSource = authDataSource ?? AuthSharedPrefLocalDataSource();

  Future<List<String>> getInterestedEventIds() async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) throw Exception('No authentication token found.');
      final response = await _dio.get(
        '$_baseUrl/events/i',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => json['event_id'].toString()).toList();
      }
      throw Exception('Failed to get interested events');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addInterest(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) throw Exception('No authentication token found.');
      final response = await _dio.post(
        '$_baseUrl/events/$eventId/interest',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removeInterest(String eventId) async {
    try {
      String? token = await _authDataSource.getToken();
      if (token == null) throw Exception('No authentication token found.');
      final response = await _dio.delete(
        '$_baseUrl/events/$eventId/interest',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
