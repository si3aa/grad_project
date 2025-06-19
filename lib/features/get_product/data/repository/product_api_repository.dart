import 'dart:developer' as developer;
import 'package:Herfa/features/get_product/data/models/all_product_data_model.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/app_interceptors.dart';

class ProductApiRepository {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true,
      headers: {
        "Authorization":
            "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiTUVSQ0hBTlQiLCJpc3MiOiJlQ29tbWVyY2UiLCJVU0VSTkFNRSI6Im1obWQiLCJleHAiOjE3NDY4OTQxOTJ9.wdfbolRgFJ28Jqskgz6ufmaokxnX11qTHpc2eoeLL0M",
      }));

  ProductApiRepository() {
    _dio.interceptors.add(AppIntercepters());
  }

  Future<List<AllproductDataModel>> getProducts() async {
    try {
      developer.log('Fetching products from API', name: 'ProductAPI');
      final response = await _dio.get('/products/active');

      developer.log('API Response status: ${response.statusCode}',
          name: 'ProductAPI');
      developer.log('API Response data type: ${response.data.runtimeType}',
          name: 'ProductAPI');
      developer.log('API Response data: ${response.data}', name: 'ProductAPI');

      if (response.statusCode == 200) {
        // Check if response.data is a Map with a 'data' field that contains the list
        if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // Check if response.data is a Map with a 'content' field that contains the list
        else if (response.data is Map && response.data['content'] != null) {
          final List<dynamic> data = response.data['content'];
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // Check if response.data itself is the list
        else if (response.data is List) {
          final List<dynamic> data = response.data;
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // If we can't find a list in the response, log the error and return an empty list
        else {
          developer.log('API Response format unexpected: ${response.data}',
              name: 'ProductAPI');
          // Try to extract any products if possible
          if (response.data is Map) {
            // Look for any array in the response
            for (var key in (response.data as Map).keys) {
              if (response.data[key] is List) {
                final List<dynamic> data = response.data[key];
                developer.log('Found list in response under key: $key',
                    name: 'ProductAPI');
                return data
                    .map((json) => AllproductDataModel.fromJson(json))
                    .toList();
              }
            }
          }
          developer.log('Could not find product list in response',
              name: 'ProductAPI');
          return [];
        }
      } else {
        developer.log(
            'API Error: ${response.statusCode} - ${response.statusMessage}',
            name: 'ProductAPI',
            error: response.data);
        throw Exception(
            'Failed to load products: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Exception in getProducts', name: 'ProductAPI', error: e);
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'ProductAPI');
        developer.log('Dio error message: ${e.message}', name: 'ProductAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'ProductAPI');
        }
      }
      throw Exception('Error fetching products: $e');
    }
  }

  /// Delete a product by ID
  Future<bool> deleteProduct(String productId) async {
    try {
      developer.log('Deleting product with ID: $productId', name: 'ProductAPI');

      final response = await _dio.delete(
        '/products/$productId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      developer.log('Delete product response: ${response.statusCode}',
          name: 'ProductAPI');

      if (response.statusCode == 200 || response.statusCode == 204) {
        developer.log('Product deleted successfully', name: 'ProductAPI');
        return true;
      } else {
        developer.log(
            'Failed to delete product: ${response.statusCode} - ${response.data}',
            name: 'ProductAPI');
        return false;
      }
    } catch (e) {
      developer.log('Error deleting product', name: 'ProductAPI', error: e);
      return false;
    }
  }

  /// Update a product by ID
  Future<bool> updateProduct(
      String productId, Map<String, dynamic> productData) async {
    try {
      developer.log('Updating product with ID: $productId', name: 'ProductAPI');
      developer.log('Update data: $productData', name: 'ProductAPI');

      final response = await _dio.put(
        '/products/$productId',
        data: productData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      developer.log('Update product response: ${response.statusCode}',
          name: 'ProductAPI');
      developer.log('Update product response data: ${response.data}',
          name: 'ProductAPI');

      if (response.statusCode == 200 || response.statusCode == 204) {
        developer.log('Product updated successfully', name: 'ProductAPI');
        return true;
      } else {
        developer.log(
            'Failed to update product: ${response.statusCode} - ${response.data}',
            name: 'ProductAPI');
        return false;
      }
    } catch (e) {
      developer.log('Error updating product', name: 'ProductAPI', error: e);
      return false;
    }
  }

  /// Get products by merchant ID
  Future<List<AllproductDataModel>> getMerchantProducts(
      String merchantId) async {
    try {
      developer.log('Fetching merchant products from API', name: 'ProductAPI');
      final response = await _dio.get('/products/merchant/$merchantId');

      developer.log('API Response status: ${response.statusCode}',
          name: 'ProductAPI');
      developer.log('API Response data type: ${response.data.runtimeType}',
          name: 'ProductAPI');
      developer.log('API Response data: ${response.data}', name: 'ProductAPI');

      if (response.statusCode == 200) {
        // Check if response.data is a Map with a 'data' field that contains the list
        if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // Check if response.data is a Map with a 'content' field that contains the list
        else if (response.data is Map && response.data['content'] != null) {
          final List<dynamic> data = response.data['content'];
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // Check if response.data itself is the list
        else if (response.data is List) {
          final List<dynamic> data = response.data;
          return data
              .map((json) => AllproductDataModel.fromJson(json))
              .toList();
        }
        // If we can't find a list in the response, log the error and return an empty list
        else {
          developer.log('API Response format unexpected: ${response.data}',
              name: 'ProductAPI');
          // Try to extract any products if possible
          if (response.data is Map) {
            // Look for any array in the response
            for (var key in (response.data as Map).keys) {
              if (response.data[key] is List) {
                final List<dynamic> data = response.data[key];
                developer.log('Found list in response under key: $key',
                    name: 'ProductAPI');
                return data
                    .map((json) => AllproductDataModel.fromJson(json))
                    .toList();
              }
            }
          }
          developer.log('Could not find product list in response',
              name: 'ProductAPI');
          return [];
        }
      } else {
        developer.log(
            'API Error: ${response.statusCode} - ${response.statusMessage}',
            name: 'ProductAPI',
            error: response.data);
        throw Exception(
            'Failed to load merchant products: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Exception in getMerchantProducts',
          name: 'ProductAPI', error: e);
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'ProductAPI');
        developer.log('Dio error message: ${e.message}', name: 'ProductAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'ProductAPI');
        }
      }
      throw Exception('Error fetching merchant products: $e');
    }
  }
}
