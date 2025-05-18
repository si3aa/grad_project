import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final String token;

  ProfileCubit({required this.repository, required this.token})
      : super(ProfileInitial());

  Future<void> updateOrCreateProfile(ProfileModel profile) async {
    emit(ProfileLoading());
    try {
      final response = await repository.updateOrCreateProfile(profile, token);
      if (response.success && response.data != null) {
        emit(ProfileSuccess(response.data!));
      } else {
        emit(ProfileError(response.message));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      return await repository.uploadProfilePicture(imageFile, token);
    } catch (e) {
      emit(ProfileError('Failed to upload image: $e'));
      return null;
    }
  }

  Future<ProfileModel> getMerchantProfile(int merchantId) async {
    return await repository.fetchMerchantProfile(merchantId, token);
  }

  Future<ProfileModel> getUserProfile(int userId) async {
    return await repository.fetchUserProfile(userId, token);
  }
}
