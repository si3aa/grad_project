import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/merchant_profile.dart';
import '../data/repository/profile_repository.dart';
import 'package:dio/dio.dart';
import 'dart:io';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final MerchantProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileNotFound extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile(String token, int userId) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.fetchProfile(token, userId);
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileNotFound());
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        emit(ProfileNotFound());
      } else {
        emit(ProfileError(e.toString()));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> createOrUpdateProfile(
      String token, Map<String, dynamic> data) async {
    emit(ProfileLoading());
    try {
      final success = await repository.createOrUpdateProfile(token, data);
      if (success) {
        emit(ProfileInitial());
      } else {
        emit(ProfileError('Failed to create/update profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<String?> uploadProfilePicture(String token, File imageFile) async {
    try {
      return await repository.uploadProfilePicture(token, imageFile);
    } catch (e) {
      emit(ProfileError('Failed to upload profile picture: $e'));
      return null;
    }
  }
}
