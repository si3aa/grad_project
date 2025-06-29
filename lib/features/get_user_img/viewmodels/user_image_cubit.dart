import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/user_image_model.dart';
import '../data/repository/user_image_repository.dart';

// States
abstract class UserImageState extends Equatable {
  const UserImageState();

  @override
  List<Object> get props => [];
}

class UserImageInitial extends UserImageState {}

class UserImageLoading extends UserImageState {}

class UserImageLoaded extends UserImageState {
  final UserImageModel userImage;

  const UserImageLoaded(this.userImage);

  @override
  List<Object> get props => [userImage];
}

class UserImageError extends UserImageState {
  final String message;

  const UserImageError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class UserImageCubit extends Cubit<UserImageState> {
  final UserImageRepository _repository;

  UserImageCubit({UserImageRepository? repository})
      : _repository = repository ?? UserImageRepository(),
        super(UserImageInitial());

  Future<void> getUserImage(int userId) async {
    try {
      developer.log('=== USER IMAGE CUBIT ===', name: 'UserImageCubit');
      developer.log('Starting to fetch user image for user ID: $userId',
          name: 'UserImageCubit');

      emit(UserImageLoading());
      developer.log('State changed to: UserImageLoading',
          name: 'UserImageCubit');

      final userImage = await _repository.getUserImage(userId);

      developer.log('Repository call successful', name: 'UserImageCubit');
      developer.log('Image URL: ${userImage.imageUrl}', name: 'UserImageCubit');

      emit(UserImageLoaded(userImage));
      developer.log('State changed to: UserImageLoaded',
          name: 'UserImageCubit');
      developer.log('=======================', name: 'UserImageCubit');
    } catch (e) {
      developer.log('=== USER IMAGE CUBIT ERROR ===', name: 'UserImageCubit');
      developer.log('Error occurred: $e', name: 'UserImageCubit');

      emit(UserImageError(e.toString()));
      developer.log('State changed to: UserImageError', name: 'UserImageCubit');
      developer.log('============================', name: 'UserImageCubit');
    }
  }

  void reset() {
    developer.log('Resetting UserImageCubit state', name: 'UserImageCubit');
    emit(UserImageInitial());
  }
}
