import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:Herfa/features/product_rating/token_helper.dart';

class ShareLinkRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<String?> getShareLink(int productId) async {
    try {
      final token = await TokenHelper.getToken();
      if (token == null) return null;
      final response = await _dio.get(
        '/products/$productId/share-link/detailed',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['shareLink'];
      }
      return null;
    } catch (e) {
      developer.log('Error getting share link',
          name: 'ShareLinkRepository', error: e);
      return null;
    }
  }
}
