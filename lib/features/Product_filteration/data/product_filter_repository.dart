import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Herfa/features/product_rating/token_helper.dart';

class ProductFilterRepository {
  final String baseUrl =
      'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products/filter/category/';

  Future<List<dynamic>> fetchProductsByCategory(int categoryId) async {
    final url = '$baseUrl$categoryId';
    print('Fetching products from: $url');
    final token = await TokenHelper.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    print('Response status: \\${response.statusCode}');
    print('Response body: \\${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['data'];
      return products is List ? products : [];
    } else {
      throw Exception('Failed to load products');
    }
  }
}
