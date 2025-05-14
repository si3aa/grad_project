import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/profile/data/models/profile_model.dart';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:Herfa/features/profile/data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final String token;

  ProfileCubit({required this.repository, required this.token})
      : super(ProfileInitial()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      developer.log('Fetching profile with token: $token',
          name: 'ProfileCubit');
      final response = await repository.fetchProfile(token);
      if (response.success && response.data != null) {
        developer.log('Profile fetch successful: ${response.data}',
            name: 'ProfileCubit');
        emit(ProfileLoaded(response.data!));
      } else {
        developer.log('Profile fetch failed: ${response.message}',
            name: 'ProfileCubit');
        emit(ProfileError(response.message));
      }
    } catch (e) {
      developer.log('Profile fetch error: $e', name: 'ProfileCubit');
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    emit(ProfileLoading());
    try {
      final response = await repository.updateProfile(profile, token);
      if (response.success && response.data != null) {
        emit(ProfileLoaded(response.data!));
      } else {
        emit(ProfileError(response.message));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    emit(ProfileLoading());
    try {
      final success = await repository.uploadProfilePicture(token, imageFile);
      if (success) {
        emit(ProfilePictureUploadSuccess());
        
        await fetchProfile();
      } else {
        emit(ProfileError('Failed to upload profile picture.'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
