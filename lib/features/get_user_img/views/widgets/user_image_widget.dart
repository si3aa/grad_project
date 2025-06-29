import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/user_image_cubit.dart';

class UserImageWidget extends StatelessWidget {
  final int userId;
  final double radius;
  final String? fallbackImage;
  final BoxShape shape;
  final VoidCallback? onTap;

  const UserImageWidget({
    Key? key,
    required this.userId,
    this.radius = 20,
    this.fallbackImage,
    this.shape = BoxShape.circle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserImageCubit()..getUserImage(userId),
      child: BlocBuilder<UserImageCubit, UserImageState>(
        builder: (context, state) {
          if (state is UserImageLoading) {
            return _buildLoadingWidget();
          } else if (state is UserImageLoaded &&
              state.userImage.imageUrl.isNotEmpty) {
            return _buildImageWidget(state.userImage.imageUrl);
          } else {
            return _buildFallbackWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: shape,
        color: Colors.grey.shade300,
      ),
      child: Center(
        child: SizedBox(
          width: radius * 0.6,
          height: radius * 0.6,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: shape,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Handle image loading error
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackWidget() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: shape,
          color: Colors.grey.shade300,
        ),
        child: Icon(
          Icons.person,
          size: radius,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
