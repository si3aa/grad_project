import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/merchant_profile.dart';
import '../models/merchant_profile.dart' show UserProfile;
import 'dart:io';
import '../models/profile_order_model.dart';
import '../models/refund_request_model.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSource([Dio? dioInstance])
      : dio = dioInstance ??
            Dio(BaseOptions(
                baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app')) {
    print(
        'ProfileRemoteDataSource using baseUrl: [1m${dio.options.baseUrl}[22m');
  }

  Future<MerchantProfile?> fetchProfile(String token, int userId) async {
    print('Fetching profile for userId: $userId');
    print('Token: $token');
    final response = await dio.get(
      '/profiles/merchant/$userId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print('Profile response status: ${response.statusCode}');
    print('Profile response data: ${response.data}');
    if (response.data['success'] == true) {
      return MerchantProfile.fromJson(response.data['data']);
    }
    return null;
  }

  Future<bool> createOrUpdateProfile(
      String token, Map<String, dynamic> data) async {
    final response = await dio.put(
      '/profiles',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  Future<String?> uploadProfilePicture(String token, File imageFile) async {
    try {
      print('Uploading file: \\${imageFile.path}');
      print('File exists: \\${await imageFile.exists()}');
      print('Token: $token');
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });
      final response = await dio.post(
        '/profiles/picture',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('Upload response: \\${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] as String?;
      }
      return null;
    } on DioException catch (e) {
      print('DioException: \\${e.message}');
      print('DioException response: \\${e.response?.data}');
      print('DioException headers: \\${e.response?.headers}');
      print('DioException request: \\${e.requestOptions.data}');
      rethrow;
    }
  }

  Future<UserProfile?> fetchUserProfile(String token, int userId) async {
    final response = await dio.get(
      '/profiles/user/$userId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return UserProfile.fromJson(response.data['data']);
    }
    return null;
  }

  Future<List<ProfileOrderModel>> fetchAllOrders(String token) async {
    final response = await dio.get(
      '/orders',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true && response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((e) => ProfileOrderModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<RefundRequestResponse> createRefundRequest(
    String token,
    int orderId,
    String reasonType,
    String message,
    List<String> imagePaths,
  ) async {
    try {
      print('Creating refund request for order: $orderId');
      print('Reason type: $reasonType');
      print('Message: $message');
      print('Image paths: $imagePaths');

      final formData = FormData();
      formData.fields
        ..add(MapEntry('reasonType', reasonType))
        ..add(MapEntry('message', message));

      // Add images if provided
      for (final imagePath in imagePaths) {
        final file = File(imagePath);
        if (await file.exists()) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              imagePath,
              filename: basename(imagePath),
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        } else {
          print('Image file does not exist: $imagePath');
        }
      }

      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files}');

      final response = await dio.post(
        '/refunds/request/$orderId',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': '*/*',
          },
          validateStatus: (_) => true,
        ),
      );

      print('Refund request response status: ${response.statusCode}');
      print('Refund request response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RefundRequestResponse.fromJson(response.data);
      } else {
        // Handle error response
        String errorMessage = 'Failed to create refund request';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        } else if (response.data is String) {
          errorMessage = response.data;
        }

        return RefundRequestResponse(
          success: false,
          message: errorMessage,
        );
      }
    } on DioException catch (e) {
      print('DioException in createRefundRequest: ${e.message}');
      print('DioException response: ${e.response?.data}');

      String errorMessage = 'Network error occurred';
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
      }

      return RefundRequestResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e) {
      print('Exception in createRefundRequest: $e');
      return RefundRequestResponse(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<List<RefundRequestModel>> fetchMyRefundRequests(String token) async {
    final response = await dio.get(
      '/refunds/my-requests',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true && response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((e) => RefundRequestModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
