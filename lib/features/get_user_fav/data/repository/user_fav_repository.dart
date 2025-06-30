import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/user_fav_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class UserFavRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  UserFavRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<UserFavModel>> getUsersWhoFavoritedProduct(
      String productId) async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Fetching users who favorited product: $productId',
          name: 'UserFavAPI');

      final response = await _dio.get(
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
        'Users who favorited response: ${response.statusCode} - ${response.data}',
        name: 'UserFavAPI',
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['success'] == true &&
          response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => UserFavModel.fromJson(json)).toList();
      }

      throw Exception('Failed to get users who favorited this product');
    } catch (e) {
      developer.log('Error fetching users who favorited product: $e',
          name: 'UserFavAPI');
      throw Exception('Failed to get users who favorited this product: $e');
    }
  }
}
