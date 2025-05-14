import 'package:Herfa/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:Herfa/features/profile/data/models/profile_model.dart';
import 'package:Herfa/features/profile/data/models/profile_response.dart';
import 'dart:io';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepository(this.remoteDataSource);

  Future<ProfileResponse> updateProfile(ProfileModel profile, String token) {
    return remoteDataSource.updateProfile(profile, token);
  }

  Future<ProfileResponse> fetchProfile(String token) {
    return remoteDataSource.fetchProfile(token);
  }

  Future<bool> uploadProfilePicture(String token, File imageFile) {
    return remoteDataSource.uploadProfilePicture(token, imageFile);
  }
}
