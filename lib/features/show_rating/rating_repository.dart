import 'dart:convert';
import 'package:Herfa/features/show_rating/data/models/rating_model.dart';
import 'package:http/http.dart' as http;

class RatingRepository {
  Future<RatingResponse> fetchAverageRating(int productId) async {
    final url = Uri.parse(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/ratings?productId=$productId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return RatingResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load rating');
    }
  }
}
