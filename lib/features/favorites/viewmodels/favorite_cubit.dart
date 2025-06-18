import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

// States
abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<String> favoriteIds;

  const FavoriteLoaded(this.favoriteIds);

  @override
  List<Object> get props => [favoriteIds];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteCubit extends Cubit<FavoriteState> {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authLocalDataSource;
  final SharedPreferences _prefs;
  List<String> _favoriteIds = [];
  static const String _favoritesKey = 'favorite_ids';

  FavoriteCubit({
    required Dio dio,
    required AuthSharedPrefLocalDataSource authLocalDataSource,
    required SharedPreferences prefs,
  })  : _dio = dio,
        _authLocalDataSource = authLocalDataSource,
        _prefs = prefs,
        super(FavoriteInitial()) {
    _loadSavedFavorites();
    loadFavorites();
  }

  List<String> get favoriteIds => _favoriteIds;

  Future<void> _loadSavedFavorites() async {
    final savedIds = _prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds = savedIds;
    print('Loaded saved favorites: $_favoriteIds');
    emit(FavoriteLoaded(_favoriteIds));
  }

  Future<void> _saveFavorites() async {
    await _prefs.setStringList(_favoritesKey, _favoriteIds);
    print('Saved favorites to local storage: $_favoriteIds');
  }

  Future<void> loadFavorites() async {
    try {
      final token = await _authLocalDataSource.getToken();
      if (token == null) {
        emit(const FavoriteError('User not authenticated'));
        return;
      }

      print('Loading favorites from API...');
      final response = await _dio.get(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/favourites',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> favoritesData = response.data;
        _favoriteIds = favoritesData
            .map((data) => data['product']['id'].toString())
            .toList();
        print('Loaded favorites from API: $_favoriteIds');
        await _saveFavorites();
        emit(FavoriteLoaded(_favoriteIds));
      }
    } catch (e) {
      print('Error loading favorites: $e');
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      final token = await _authLocalDataSource.getToken();
      if (token == null) {
        emit(const FavoriteError('User not authenticated'));
        return;
      }

      final isFavorite = _favoriteIds.contains(productId);
      print(
          'Current state for product $productId: ${isFavorite ? "favorited" : "not favorited"}');

      final url =
          'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/favourites/$productId';

      if (isFavorite) {
        // Remove from favorites
        print('Attempting to remove product $productId from favorites...');
        final response = await _dio.delete(
          url,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        print('Remove from Favorites API Response: ${response.data}');

        if (response.statusCode == 200) {
          _favoriteIds.remove(productId);
          print('Successfully removed product $productId from favorites');
          await _saveFavorites();
          emit(FavoriteLoaded(_favoriteIds));
        } else {
          print(
              'Failed to remove product $productId from favorites. Status code: ${response.statusCode}');
          emit(const FavoriteError('Failed to remove from favorites'));
        }
      } else {
        // Add to favorites
        print('Attempting to add product $productId to favorites...');
        final response = await _dio.post(
          url,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        print('Add to Favorites API Response: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          _favoriteIds.add(productId);
          print('Successfully added product $productId to favorites');
          await _saveFavorites();
          emit(FavoriteLoaded(_favoriteIds));
        } else {
          print(
              'Failed to add product $productId to favorites. Status code: ${response.statusCode}');
          emit(const FavoriteError('Failed to add to favorites'));
        }
      }
    } catch (e) {
      print('Error toggling favorite for product $productId: $e');
      emit(FavoriteError(e.toString()));
    }
  }

  bool isProductFavorite(String productId) {
    final isFavorite = _favoriteIds.contains(productId);
    print(
        'Checking favorite status for product $productId: ${isFavorite ? "favorited" : "not favorited"}');
    return isFavorite;
  }
}
