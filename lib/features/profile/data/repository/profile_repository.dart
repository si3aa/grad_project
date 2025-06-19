import '../models/merchant_profile.dart';
import '../data_source/profile_remote_data_source.dart';
import 'dart:io';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepository(this.remoteDataSource);

  Future<MerchantProfile?> fetchProfile(String token, int userId) {
    return remoteDataSource.fetchProfile(token, userId);
  }

  Future<bool> createOrUpdateProfile(String token, Map<String, dynamic> data) {
    return remoteDataSource.createOrUpdateProfile(token, data);
  }

  Future<String?> uploadProfilePicture(String token, File imageFile) {
    return remoteDataSource.uploadProfilePicture(token, imageFile);
  }
}
