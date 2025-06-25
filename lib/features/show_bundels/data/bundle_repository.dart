import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Herfa/features/show_bundels/data/bundle_model.dart';
import 'package:Herfa/features/product_rating/token_helper.dart';

class BundleRepository {
  static const String _baseUrl =
      'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/bundles';

  Future<List<BundleModel>> fetchBundles() async {
    final token = await TokenHelper.getToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => BundleModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to fetch bundles: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch bundles: ${response.statusCode}');
    }
  }

  Future<void> deleteBundle(int bundleId) async {
    final token = await TokenHelper.getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/$bundleId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete bundle: \\${response.statusCode}');
    }
  }
}
