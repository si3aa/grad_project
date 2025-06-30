import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Herfa/features/product_rating/token_helper.dart';

class ChangeRoleRepository {
  final String baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<Map<String, dynamic>> changeRole(
      String username, String password) async {
    final token = await TokenHelper.getToken();
    final url = Uri.parse('$baseUrl/auth/promote');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'username': username,
      'password': password,
    });

    print('--- Change Role Request ---');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: $body');

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print('--- Change Role Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to change role: ${response.statusCode}');
    }
  }
}
