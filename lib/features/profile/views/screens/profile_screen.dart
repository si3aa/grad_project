import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/profile/viewmodel/cubit/profile_cubit.dart';
import 'package:Herfa/features/profile/data/repositories/profile_repository.dart';
import 'package:Herfa/features/profile/data/data_source/remote/profile_remote_data_source.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/core/route_manger/routes.dart';

String buildImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  const String baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/';
  if (path.startsWith('http')) return path;
  if (path.startsWith('/')) {
    return baseUrl + path.substring(1);
  }
  return baseUrl + path;
}

class ProfileScreen extends StatefulWidget {
  final String? token;
  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedImage;

  ImageProvider? _getAvatarImage(profile) {
    if (_pickedImage != null) {
      return FileImage(_pickedImage!);
    }
    final url = profile.profilePictureUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http')) {
        return NetworkImage(url);
      } else if (url.startsWith('/')) {
        return NetworkImage(buildImageUrl(url));
      }
    }
    return null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
      context.read<ProfileCubit>().uploadProfilePicture(_pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = widget.token;
    if (token == null) {
      return const Scaffold(
        body: Center(child: Text('No token provided')),
      );
    }

    return BlocProvider(
      create: (_) => ProfileCubit(
        repository: ProfileRepository(ProfileRemoteDataSource(Dio())),
        token: token,
      ),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePictureUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile picture uploaded!')),
            );
            setState(() {
              _pickedImage = null;
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ProfileError) {
            log(state.message);
            return Scaffold(
              body: Center(
                  child: Text('Failed to load profile. Please try again.')),
            );
          }
          if (state is ProfileLoaded) {
            final profile = state.profile;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Your Profile'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.loginRoute,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: _getAvatarImage(profile),
                        child: (_pickedImage == null &&
                                (profile.profilePictureUrl == null ||
                                    profile.profilePictureUrl!.isEmpty))
                            ? const Icon(Icons.person, size: 48)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload),
                      label: const Text('Change Profile Picture'),
                      onPressed: _pickImage,
                    ),
                    Text(
                      '${profile.firstName ?? ''} ${profile.lastName ?? ''}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(profile.phone ?? '',
                        style: const TextStyle(color: Colors.grey)),
                    Text(profile.address ?? '',
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(profile.bio ?? '',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        'Favorite shops',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        },
      ),
    );
  }
}
