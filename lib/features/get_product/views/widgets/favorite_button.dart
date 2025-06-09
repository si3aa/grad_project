import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'dart:developer' as developer;

class FavoriteButton extends StatefulWidget {
  final String productId;
  final bool initialIsFavorite;
  final Function(bool) onFavoriteChanged;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.initialIsFavorite = false,
    required this.onFavoriteChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;
  final Dio _dio = Dio();
  final AuthSharedPrefLocalDataSource _authDataSource = AuthSharedPrefLocalDataSource();

  @override
  void initState() {
    super.initState();
    // Always start as unfavorited - NO API check
    _isFavorite = false;
    widget.onFavoriteChanged(false);

    // Validate product ID
    if (widget.productId == '0' || widget.productId.isEmpty) {
      developer.log('⚠️ Invalid product ID: "${widget.productId}" - favorites will not work');
    } else {
      developer.log('🤍 Product ${widget.productId} initialized as UNFAVORITED - Icon is UNCOLORED');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final token = await _authDataSource.getToken();
      developer.log('Checking favorite status for product: ${widget.productId}');
      developer.log('Token: ${token != null ? "Present" : "Missing"}');

      if (token == null || token.isEmpty) {
        developer.log('No token available - user not logged in');
        setState(() => _isFavorite = false);
        widget.onFavoriteChanged(false);
        return;
      }

      final response = await _dio.get(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/favourites/${widget.productId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Accept all status codes < 500
        ),
      );

      developer.log('Check favorite status response: ${response.statusCode}');
      developer.log('Check favorite response data: ${response.data}');

      if (response.statusCode == 200) {
        setState(() => _isFavorite = true);
        widget.onFavoriteChanged(true);
        developer.log('✅ Product ${widget.productId} IS ALREADY FAVORITED - Icon will be COLORED ❤️');
      } else if (response.statusCode == 404) {
        setState(() => _isFavorite = false);
        widget.onFavoriteChanged(false);
        developer.log('⭕ Product ${widget.productId} is NOT favorited (404) - Icon will be UNCOLORED 🤍');
      } else {
        setState(() => _isFavorite = false);
        widget.onFavoriteChanged(false);
        developer.log('⭕ Product ${widget.productId} status unknown (${response.statusCode}) - Icon will be UNCOLORED 🤍');
      }
    } on DioException catch (e) {
      developer.log('DioException checking favorite status: ${e.type} - ${e.message}');
      developer.log('DioException response: ${e.response?.statusCode} - ${e.response?.data}');
      setState(() => _isFavorite = false);
      widget.onFavoriteChanged(false);
    } catch (e) {
      developer.log('Unexpected error checking favorite status: $e');
      setState(() => _isFavorite = false);
      widget.onFavoriteChanged(false);
    }
  }

  Future<void> _handleFavoriteAction(bool isAdding) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final token = await _authDataSource.getToken();
      final url = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/favourites/${widget.productId}';

      developer.log('User clicked to ${isAdding ? "ADD" : "REMOVE"} favorite for product: ${widget.productId}');
      developer.log('Current state: ${_isFavorite ? "FAVORITED" : "NOT FAVORITED"}');
      developer.log('Target state: ${isAdding ? "FAVORITED" : "NOT FAVORITED"}');
      developer.log('Token: ${token != null ? "Present" : "Missing"}');
      developer.log('URL: $url');

      // Check if user is logged in
      if (token == null || token.isEmpty) {
        developer.log('No token available - user not logged in');
        _showErrorSnackBar('Please login to add favorites');
        return;
      }

      final response = isAdding
          ? await _dio.post(
              url,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                validateStatus: (status) => status! < 500, // Accept all status codes < 500
              ),
            )
          : await _dio.delete(
              url,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                validateStatus: (status) => status! < 500, // Accept all status codes < 500
              ),
            );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        setState(() => _isFavorite = isAdding);
        widget.onFavoriteChanged(isAdding);

        if (isAdding) {
          developer.log('✅ SUCCESS! Product ${widget.productId} ADDED TO favorites');
          developer.log('🎨 Icon is now COLORED (red heart) ❤️');
          developer.log('📱 User sees: Favorited product');
          _showSuccessMessage('Added to favorites');
        } else {
          developer.log('✅ SUCCESS! Product ${widget.productId} REMOVED FROM favorites');
          developer.log('🎨 Icon is now UNCOLORED (gray outline) 🤍');
          developer.log('📱 User sees: Unfavorited product');
          _showSuccessMessage('Removed from favorites');
        }
      } else if (response.statusCode == 201) {
        // Some APIs return 201 for successful creation
        setState(() => _isFavorite = isAdding);
        widget.onFavoriteChanged(isAdding);

        developer.log('Success (201)! Product ${widget.productId} ${isAdding ? "added to" : "removed from"} favorites');
        _showSuccessMessage(isAdding ? 'Added to favorites' : 'Removed from favorites');
      } else if (response.statusCode == 404) {
        developer.log('Product not found (404)');
        _showErrorSnackBar('Product not found');
      } else if (response.statusCode == 401) {
        developer.log('Unauthorized (401) - token may be expired');
        _showErrorSnackBar('Please login again to add favorites');
      } else if (response.statusCode == 409) {
        // Conflict - item might already be in favorites
        if (isAdding) {
          developer.log('Product already in favorites (409)');
          setState(() => _isFavorite = true);
          widget.onFavoriteChanged(true);
          _showSuccessMessage('Product is already in favorites');
        } else {
          developer.log('Product not in favorites to remove (409)');
          setState(() => _isFavorite = false);
          widget.onFavoriteChanged(false);
          _showSuccessMessage('Product was not in favorites');
        }
      } else {
        developer.log('Failed to ${isAdding ? "add to" : "remove from"} favorites. Status: ${response.statusCode}');
        _showErrorSnackBar(_getErrorMessage(response.statusCode ?? 0, isAdding));
      }
    } on DioException catch (e) {
      developer.log('DioException in favorite action: ${e.type} - ${e.message}');
      developer.log('DioException response: ${e.response?.statusCode} - ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        _showErrorSnackBar('Connection timeout. Please try again.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _showErrorSnackBar('Server response timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        _showErrorSnackBar('No internet connection. Please check your network.');
      } else if (e.response?.statusCode == 401) {
        _showErrorSnackBar('Please login again to add favorites');
      } else if (e.response?.statusCode == 404) {
        _showErrorSnackBar('Product not found');
      } else {
        _showErrorSnackBar('Network error. Please try again.');
      }
    } catch (e) {
      developer.log('Unexpected error in favorite action: $e');
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return; // Check if widget is still mounted

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return; // Check if widget is still mounted

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // Retry the last action
            _checkFavoriteStatus();
          },
        ),
      ),
    );
  }

  String _getErrorMessage(int statusCode, bool isAdding) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Please login again to add favorites';
      case 403:
        return 'You don\'t have permission to perform this action';
      case 404:
        return 'Product not found';
      case 409:
        return isAdding ? 'Product already in favorites' : 'Product not in favorites';
      case 422:
        return 'Invalid product data';
      case 429:
        return 'Too many requests. Please wait a moment.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Server temporarily unavailable. Please try again.';
      default:
        return 'Failed to ${isAdding ? "add to" : "remove from"} favorites (Error: $statusCode)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Single tap: Toggle favorite state
        if (_isFavorite) {
          // Product is currently FAVORITED (colored icon) -> REMOVE from favorites (make uncolored)
          developer.log('🔴 User clicked on FAVORITED product ${widget.productId} -> REMOVING from favorites');
          _handleFavoriteAction(false);
        } else {
          // Product is currently UNFAVORITED (uncolored icon) -> ADD to favorites (make colored)
          developer.log('⚪ User clicked on UNFAVORITED product ${widget.productId} -> ADDING to favorites');
          _handleFavoriteAction(true);
        }
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey.shade400,
                size: 22,
              ),
      ),
    );
  }
}
