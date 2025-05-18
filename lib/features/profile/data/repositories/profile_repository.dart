import 'dart:io';
import '../models/profile_model.dart';
import '../models/profile_response.dart';
import '../data_source/remote/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepository(this.remoteDataSource);

  Future<ProfileResponse> updateOrCreateProfile(
      ProfileModel profile, String token) {
    return remoteDataSource.updateOrCreateProfile(profile, token);
  }

  Future<String?> uploadProfilePicture(File imageFile, String token) {
    return remoteDataSource.uploadProfilePicture(imageFile, token);
  }

  Future<ProfileModel> fetchMerchantProfile(int merchantId, String token) {
    return remoteDataSource.fetchMerchantProfile(merchantId, token);
  }

  Future<ProfileModel> fetchUserProfile(int userId, String token) {
    return remoteDataSource.fetchUserProfile(userId, token);
  }
}
