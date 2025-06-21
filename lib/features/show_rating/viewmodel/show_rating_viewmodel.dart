import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/show_rating_model.dart';
import 'package:Herfa/features/product_rating/token_helper.dart';

class ShowRatingViewModel extends ChangeNotifier {
  double? _rating;
  bool _isLoading = false;
  String? _error;

  double? get rating => _rating;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRating(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final token = await TokenHelper.getToken();
      final url = Uri.parse('https://zygotic-marys-herfa-c2dd67a8.koyeb.app/ratings?productId=$productId');
      final response = await http.get(
        url,
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );
      print('ShowRatingViewModel: status=${response.statusCode}, body=${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _rating = ShowRatingModel.fromJson(data).rating;
      } else {
        _error = 'Failed to load rating';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
