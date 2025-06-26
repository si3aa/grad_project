import 'package:dio/dio.dart';

class FavRepository {
  final Dio _dio;
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  FavRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<String>> getFavoriteProductIds(String token) async {
    try {
      print('Token used for getFavoriteProductIds: $token');
      final response = await _dio.get(
        '$_baseUrl/favourites',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          'getFavoriteProductIds response: \\${response.statusCode} - \\${response.data}');
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => json['product_id'].toString()).toList();
      }
      throw Exception('Failed to get favorites');
    } catch (e) {
      print('getFavoriteProductIds error: $e');
      rethrow;
    }
  }

  Future<bool> addFavorite(String token, String productId) async {
    try {
      print('Token used for addFavorite: $token');
      final response = await _dio.post(
        '$_baseUrl/favourites',
        data: {'product_id': productId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          'addFavorite response: \\${response.statusCode} - \\${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('addFavorite error: $e');
      rethrow;
    }
  }

  Future<bool> removeFavorite(String token, String productId) async {
    try {
      print('Token used for removeFavorite: $token');
      final response = await _dio.delete(
        '$_baseUrl/favourites/$productId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          'removeFavorite response: \\${response.statusCode} - \\${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('removeFavorite error: $e');
      rethrow;
    }
  }
}
