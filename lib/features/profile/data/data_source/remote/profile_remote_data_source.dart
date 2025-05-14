import 'package:dio/dio.dart';
import 'package:Herfa/features/profile/data/models/profile_model.dart';
import 'package:Herfa/features/profile/data/models/profile_response.dart';
import 'dart:developer' as developer;
import 'dart:io';

class ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSource(Dio dio)
      : dio = dio
          ..options.baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/';

  Future<ProfileResponse> updateProfile(
      ProfileModel profile, String token) async {
    final response = await dio.put(
      'profiles',
      data: profile.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> fetchProfile(String token) async {
    developer.log('Fetching profile with token: $token', name: 'ProfileAPI');
    final response = await dio.put(
      'profiles',
      data: {},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    developer.log('Profile fetch response status: ${response.statusCode}',
        name: 'ProfileAPI');
    developer.log('Profile fetch response data: ${response.data}',
        name: 'ProfileAPI');
    return ProfileResponse.fromJson(response.data);
  }

  Future<bool> uploadProfilePicture(String token, File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
    });
    final response = await dio.post(
      'profiles/picture',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return response.data['success'] == true;
  }
}
