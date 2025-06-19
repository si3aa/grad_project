import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/merchant_profile.dart';
import 'dart:io';

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
}
