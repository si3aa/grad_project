import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/comment_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class CommentRepository {
  final Dio _dio = Dio();
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await _authDataSource.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<CommentModel>> fetchComments(String productId) async {
    try {
      developer.log('Fetching comments for product: $productId',
          name: 'CommentAPI');

      final response = await _dio.get(
        '$_baseUrl/comments/product/$productId',
        options: Options(headers: await _getHeaders()),
      );

      developer.log(
          'Comments response: ${response.statusCode} - ${response.data}',
          name: 'CommentAPI');

      if (response.statusCode == 200) {
        if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          return data.map((json) => CommentModel.fromJson(json)).toList();
        } else if (response.data is List) {
          return (response.data as List)
              .map((json) => CommentModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      developer.log('DioException fetching comments: ${e.message}',
          name: 'CommentAPI', error: e);
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        throw Exception('Please sign in to view comments');
      }
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to fetch comments');
    } catch (e) {
      developer.log('Error fetching comments: $e',
          name: 'CommentAPI', error: e);
      throw Exception('Failed to fetch comments');
    }
  }

  Future<bool> postComment(String productId, String content) async {
    try {
      developer.log('Posting comment for product: $productId',
          name: 'CommentAPI');

      final response = await _dio.post(
        '$_baseUrl/comments',
        queryParameters: {
          'productId': productId,
          'content': content,
        },
        options: Options(headers: await _getHeaders()),
      );

      developer.log(
          'Post comment response: ${response.statusCode} - ${response.data}',
          name: 'CommentAPI');

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      developer.log('DioException posting comment: ${e.message}',
          name: 'CommentAPI', error: e);
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        throw Exception('Please sign in to post comments');
      }
      throw Exception(e.response?.data?['message'] ?? 'Failed to post comment');
    } catch (e) {
      developer.log('Error posting comment: $e', name: 'CommentAPI', error: e);
      throw Exception('Failed to post comment');
    }
  }

  Future<bool> updateComment(String commentId, String newContent) async {
    try {
      developer.log('Updating comment: $commentId', name: 'CommentAPI');

      final response = await _dio.put(
        '$_baseUrl/comments/$commentId',
        queryParameters: {
          'newContent': newContent,
        },
        options: Options(headers: await _getHeaders()),
      );

      developer.log(
          'Update response: ${response.statusCode} - ${response.data}',
          name: 'CommentAPI');

      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      developer.log('DioException updating comment: ${e.message}',
          name: 'CommentAPI', error: e);
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        throw Exception('Please sign in to edit comments');
      }
      throw Exception(
          e.response?.data?['message'] ?? 'Failed to update comment');
    } catch (e) {
      developer.log('Error updating comment: $e', name: 'CommentAPI', error: e);
      throw Exception('Failed to update comment');
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      developer.log('Attempting to delete comment with ID: $commentId',
          name: 'CommentAPI');

      // Get headers with authentication token
      final headers = await _getHeaders();

      // Make DELETE request to the API
      final response = await _dio.delete(
        '$_baseUrl/comments/$commentId',
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
      );

      developer.log(
          'Delete comment response: ${response.statusCode} - ${response.data}',
          name: 'CommentAPI');

      // Check response status
      if (response.statusCode == 200 || response.statusCode == 204) {
        developer.log('Comment deleted successfully', name: 'CommentAPI');
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication required to delete comments');
      } else if (response.statusCode == 404) {
        throw Exception('Comment not found');
      } else {
        throw Exception(
            response.data?['message'] ?? 'Failed to delete comment');
      }
    } on DioException catch (e) {
      developer.log('DioException while deleting comment: ${e.message}',
          name: 'CommentAPI', error: e);

      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Exception('Authentication required to delete comments');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Comment not found');
      } else {
        throw Exception(
            e.response?.data?['message'] ?? 'Failed to delete comment');
      }
    } catch (e) {
      developer.log('Unexpected error while deleting comment: $e',
          name: 'CommentAPI', error: e);
      throw Exception(
          'An unexpected error occurred while deleting the comment');
    }
  }
}
