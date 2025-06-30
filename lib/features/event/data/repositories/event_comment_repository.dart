import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/event_comment_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class EventCommentRepository {
  final Dio _dio = Dio();
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<List<EventCommentModel>> fetchComments(String eventId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Fetching comments for event: $eventId',
          name: 'EventCommentAPI');
      final response = await _dio.get(
        '$_baseUrl/events/$eventId/comments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      developer.log(
          'Comments response: ${response.statusCode} - ${response.data}',
          name: 'EventCommentAPI');

      if (response.statusCode == 200) {
        if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          return data.map((json) => EventCommentModel.fromJson(json)).toList();
        } else if (response.data is List) {
          // Handle case where response is directly a list
          return (response.data as List)
              .map((json) => EventCommentModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      developer.log('Error fetching comments: $e', name: 'EventCommentAPI');
      return [];
    }
  }

  Future<bool> postComment(String eventId, String content) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Posting comment for event: $eventId',
          name: 'EventCommentAPI');
      final response = await _dio.post(
        '$_baseUrl/events/$eventId/comments',
        queryParameters: {
          'commentText': content,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      developer.log(
          'Post comment response: ${response.statusCode} - ${response.data}',
          name: 'EventCommentAPI');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      developer.log('Error posting comment: $e', name: 'EventCommentAPI');
      return false;
    }
  }

  Future<bool> deleteComment(String eventId, String commentId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Deleting comment with ID: $commentId',
          name: 'EventCommentAPI');
      final response = await _dio.delete(
        '$_baseUrl/events/$eventId/comments/$commentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      developer.log(
          'Delete comment response: ${response.statusCode} - ${response.data}',
          name: 'EventCommentAPI');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      developer.log('Error deleting comment: $e', name: 'EventCommentAPI');
      return false;
    }
  }

  Future<bool> editComment(String eventId, String commentId, String content) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Editing comment with ID: $commentId', name: 'EventCommentAPI');
      final response = await _dio.put(
        '$_baseUrl/events/$eventId/comments/$commentId',
        queryParameters: {
          'commentText': content,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      developer.log('Edit comment response: ${response.statusCode} - ${response.data}',
          name: 'EventCommentAPI');
      return response.statusCode == 200;
    } catch (e) {
      developer.log('Error editing comment: $e', name: 'EventCommentAPI');
      return false;
    }
  }
}
