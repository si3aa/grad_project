import 'dart:io';
import 'package:Herfa/features/profile/data/models/profile_model.dart';
import 'package:Herfa/features/profile/data/models/profile_response.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSource(this.dio);

  Future<ProfileResponse> updateOrCreateProfile(
      ProfileModel profile, String token) async {
    try {
      developer.log('Updating profile with data: ${profile.toJson()}',
          name: 'ProfileAPI');

      final response = await dio.put(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/profiles',
        data: profile.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => true,
        ),
      );

      developer.log('Profile update response: ${response.data}',
          name: 'ProfileAPI');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? response.statusMessage
            : response.statusMessage;
        throw Exception('Failed to update profile: $errorMessage');
      }

      return ProfileResponse.fromJson(response.data);
    } catch (e) {
      developer.log('Profile update error: $e', name: 'ProfileAPI');
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'ProfileAPI');
        developer.log('Dio error message: ${e.message}', name: 'ProfileAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'ProfileAPI');
        }
      }
      rethrow;
    }
  }

  Future<String?> uploadProfilePicture(File imageFile, String token) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });

      developer.log('Uploading profile picture...', name: 'ProfileAPI');

      final response = await dio.post(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/profiles/picture',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      developer.log('Profile picture upload response: ${response.data}',
          name: 'ProfileAPI');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? response.statusMessage
            : response.statusMessage;
        throw Exception('Failed to upload profile picture: $errorMessage');
      }

      if (response.data['success'] == true && response.data['url'] != null) {
        return response.data['url'];
      }
      return null;
    } catch (e) {
      developer.log('Profile picture upload error: $e', name: 'ProfileAPI');
      if (e is DioException) {
        developer.log('Dio error type: ${e.type}', name: 'ProfileAPI');
        developer.log('Dio error message: ${e.message}', name: 'ProfileAPI');
        if (e.response != null) {
          developer.log('Dio error response: ${e.response?.data}',
              name: 'ProfileAPI');
        }
      }
      rethrow;
    }
  }

  Future<ProfileModel> fetchMerchantProfile(
      int merchantId, String token) async {
    final response = await dio.get(
      'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/profiles/merchant/$merchantId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProfileModel.fromJson(response.data['data']);
  }

  Future<ProfileModel> fetchUserProfile(int userId, String token) async {
    final response = await dio.get(
      'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/profiles/user/$userId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProfileModel.fromJson(response.data['data']);
  }
}
