import 'package:http/http.dart' as http;
import 'package:Herfa/features/product_rating/token_helper.dart';
import 'dart:convert';

class FollowRepository {
  final String _baseUrl = 'http://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<bool> followUser(int userId) async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('No authentication token found.');
    final url = Uri.parse('$_baseUrl/follow/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('--- Follow Request ---');
    print('URL: $url');
    print('Headers: $headers');
    final response = await http.post(url, headers: headers);
    print('--- Follow Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to follow user: ${response.statusCode}');
    }
  }

  Future<bool> unfollowUser(int userId) async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('No authentication token found.');
    final url = Uri.parse('$_baseUrl/follow/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('--- Unfollow Request ---');
    print('URL: $url');
    print('Headers: $headers');
    final response = await http.delete(url, headers: headers);
    print('--- Unfollow Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to unfollow user: ${response.statusCode}');
    }
  }

  Future<List<int>> getFollowings() async {
    final token = await TokenHelper.getToken();
    if (token == null) throw Exception('No authentication token found.');
    final url = Uri.parse('$_baseUrl/follow/followings');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('--- Get Followings Request ---');
    print('URL: $url');
    print('Headers: $headers');
    final response = await http.get(url, headers: headers);
    print('--- Get Followings Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assuming the response is a list of user IDs
      if (data is List) {
        return data
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .where((id) => id != 0)
            .toList();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .where((id) => id != 0)
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get followings: ${response.statusCode}');
    }
  }
}
