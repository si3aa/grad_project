import 'dart:developer';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:dio/dio.dart';
import '../models/saved_product_model.dart';
import '../models/product_details_model.dart';

class SavedProductRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

  Future<bool> saveProduct(String productId) async {
    try {
      log('Saving product with ID: $productId');
      final response = await _dio.post(
        '$_baseUrl/saving-products/$productId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken()}',
          },
        ),
      );
      log('Save product response: ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      log('Error saving product: $e');
      throw Exception('Failed to save product: $e');
    }
  }

  Future<List<SavedProductModel>> getSavedProducts() async {
    try {
      log('Fetching saved products');
      final response = await _dio.get(
        '$_baseUrl/saving-products',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken()}',
          },
        ),
      );

      log('Get saved products response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((json) => SavedProductModel.fromJson(json)).toList();
        } else if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          return data.map((json) => SavedProductModel.fromJson(json)).toList();
        } else if (response.data is Map && response.data['content'] != null) {
          final List<dynamic> data = response.data['content'];
          return data.map((json) => SavedProductModel.fromJson(json)).toList();
        } else {
          log('Unexpected response format: ${response.data}');
          return [];
        }
      } else {
        throw Exception('Failed to load saved products');
      }
    } catch (e) {
      log('Error fetching saved products: $e');
      throw Exception('Failed to load saved products: $e');
    }
  }

  Future<bool> removeSavedProduct(String productId) async {
    try {
      log('Removing saved product with ID: $productId');
      final response = await _dio.delete(
        '$_baseUrl/saving-products/$productId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken()}',
          },
        ),
      );
      log('Remove saved product response: ${response.statusCode}, data: ${response.data}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      log('Error removing saved product: $e');
      throw Exception('Failed to remove saved product: $e');
    }
  }

  Future<String?> _getToken() async {
    final authLocalDataSource = AuthSharedPrefLocalDataSource();
    return await authLocalDataSource.getToken();
  }

  Future<List<ProductDetailsModel>> getSavedProductsWithDetails() async {
    try {
      log('Fetching saved products with details');
      final response = await _dio.get(
        '$_baseUrl/saving-products',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getToken()}',
          },
        ),
      );

      log('Get saved products with details response: ${response.data}');
      if (response.statusCode == 200) {
        List<dynamic> data;
        if (response.data is List) {
          data = response.data;
        } else if (response.data is Map && response.data['data'] != null) {
          data = response.data['data'];
        } else if (response.data is Map && response.data['content'] != null) {
          data = response.data['content'];
        } else {
          log('Unexpected response format: ${response.data}');
          return [];
        }

        // Convert API response to ProductDetailsModel
        return data.map((json) {
          // Log the raw JSON for debugging
          log('Processing product JSON: $json');

          // Safely convert ID to string regardless of its original type
          String id = '';
          if (json['productId'] != null) {
            id = json['productId'].toString();
          } else if (json['id'] != null) {
            id = json['id'].toString();
          }

          // Safely convert userId to string
          String userId = '';
          if (json['userId'] != null) {
            userId = json['userId'].toString();
          }

          // Extract product details from the API response with proper type handling
          return ProductDetailsModel(
            id: id,
            name: json['name']?.toString() ?? 'Unknown Product',
            title: json['shortDescription']?.toString() ?? '',
            description: json['longDescription']?.toString() ?? '',
            price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
            discountedPrice:
                double.tryParse(json['discountedPrice']?.toString() ?? '0') ??
                    0.0,
            discountPercentage:
                int.tryParse(json['discountPercentage']?.toString() ?? '0') ??
                    0,
            rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
            reviewCount:
                int.tryParse(json['reviewCount']?.toString() ?? '0') ?? 0,
            images: json['media'] != null
                ? [json['media'].toString()]
                : ['assets/images/product_1.png'],
            userId: userId,
            userName: json['userName']?.toString() ?? 'Unknown Seller',
            userImage:
                json['userImage']?.toString() ?? 'assets/images/user.png',
          );
        }).toList();
      } else {
        throw Exception('Failed to load saved products with details');
      }
    } catch (e) {
      log('Error fetching saved products with details: $e');
      throw Exception('Failed to load saved products with details: $e');
    }
  }
}
