import 'package:flutter/material.dart';
import '../data/fav_repository.dart';

class FavViewModel extends ChangeNotifier {
  final FavRepository repository;
  final String token;
  List<String> _favoriteProductIds = [];
  bool _loading = false;

  FavViewModel({required this.repository, required this.token});

  List<String> get favoriteProductIds => _favoriteProductIds;
  bool get loading => _loading;

  Future<void> fetchFavorites() async {
    _loading = true;
    notifyListeners();
    try {
      _favoriteProductIds = await repository.getFavoriteProductIds(token);
    } catch (e) {
      print('fetchFavorites error: $e');
      _favoriteProductIds = [];
    }
    _loading = false;
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  Future<void> toggleFavorite(String productId) async {
    _loading = true;
    notifyListeners();
    try {
      if (isFavorite(productId)) {
        final success = await repository.removeFavorite(token, productId);
        if (success) _favoriteProductIds.remove(productId);
      } else {
        final success = await repository.addFavorite(token, productId);
        if (success) _favoriteProductIds.add(productId);
      }
    } catch (e) {
      print('toggleFavorite error: $e');
    }
    _loading = false;
    notifyListeners();
  }
}
