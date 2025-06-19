import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/favorite_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class FavoriteRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  FavoriteRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Fetching favorites', name: 'FavoriteAPI');

      final response = await _dio.get(
        '$_baseUrl/favourites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      developer.log(
        'Favorites response: ${response.statusCode} - ${response.data}',
        name: 'FavoriteAPI',
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => FavoriteModel.fromJson(json)).toList();
      }
      throw Exception('Failed to get favorites');
    } catch (e) {
      developer.log('Error fetching favorites: $e', name: 'FavoriteAPI');
      throw Exception('Failed to get favorites: $e');
    }
  }

  Future<bool> addToFavorites(String productId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Adding product to favorites: $productId',
          name: 'FavoriteAPI');

      final response = await _dio.post(
        '$_baseUrl/favourites',
        data: {'product_id': productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      developer.log(
        'Add to favorites response: ${response.statusCode} - ${response.data}',
        name: 'FavoriteAPI',
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      developer.log('Error adding to favorites: $e', name: 'FavoriteAPI');
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<bool> removeFromFavorites(String productId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Removing product from favorites: $productId',
          name: 'FavoriteAPI');

      final response = await _dio.delete(
        '$_baseUrl/favourites/$productId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      developer.log(
        'Remove from favorites response: ${response.statusCode} - ${response.data}',
        name: 'FavoriteAPI',
      );

      return response.statusCode == 200;
    } catch (e) {
      developer.log('Error removing from favorites: $e', name: 'FavoriteAPI');
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}
