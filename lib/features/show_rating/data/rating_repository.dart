import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/rating_model.dart';

class RatingRepository {
  Future<RatingResponse> fetchAverageRating(int productId) async {
    final url = Uri.parse(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/ratings?productId=$productId');
    final response = await http.get(url);
    print('API response status: ${response.statusCode}');
    print('API response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return RatingResponse.fromJson(jsonBody);
    } else {
      print('API error: status code ${response.statusCode}');
      throw Exception('Failed to load rating');
    }
  }
}
