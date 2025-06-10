import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/comment_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class CommentRepository {
  final Dio _dio = Dio();
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<List<CommentModel>> fetchComments(String productId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Fetching comments for product: $productId',
          name: 'CommentAPI');
      final response = await _dio.get(
        '$_baseUrl/comments/product/$productId',
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
          name: 'CommentAPI');
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      developer.log('Error fetching comments: $e', name: 'CommentAPI');
      return [];
    }
  }

  Future<bool> postComment(String productId, String content) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Posting comment for product: $productId',
          name: 'CommentAPI');
      final response = await _dio.post(
        '$_baseUrl/comments',
        queryParameters: {
          'productId': productId,
          'content': content,
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
          name: 'CommentAPI');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      developer.log('Error posting comment: $e', name: 'CommentAPI');
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Deleting comment with ID: $commentId', name: 'CommentAPI');
      final response = await _dio.delete(
        '$_baseUrl/comments/$commentId',
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
          name: 'CommentAPI');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      developer.log('Error deleting comment: $e', name: 'CommentAPI');
      return false;
    }
  }
}
