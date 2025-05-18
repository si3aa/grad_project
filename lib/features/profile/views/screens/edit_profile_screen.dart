import 'dart:io';
import 'package:Herfa/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/data_source/remote/profile_remote_data_source.dart';
import '../../viewmodel/cubit/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'user_profile_screen.dart';
import 'merchant_profile_screen.dart';

class EditProfileScreen extends StatelessWidget {
  final String token;
  final ProfileModel? profile;
  const EditProfileScreen({super.key, required this.token, this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        repository: ProfileRepository(ProfileRemoteDataSource(Dio())),
        token: token,
      ),
      child: EditProfileForm(profile: profile, token: token),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final ProfileModel? profile;
  final String token;
  const EditProfileForm({super.key, this.profile, required this.token});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController bioController;
  bool obscurePassword = true;
  File? pickedImage;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.profile?.firstName ?? '');
    lastNameController =
        TextEditingController(text: widget.profile?.lastName ?? '');

    passwordController =
        TextEditingController(); // Not stored in profile, left empty
    phoneController = TextEditingController(text: widget.profile?.phone ?? '');
    addressController =
        TextEditingController(text: widget.profile?.address ?? '');
    bioController = TextEditingController(text: widget.profile?.bio ?? '');
    profileImageUrl = widget.profile?.profilePictureUrl;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();

    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        pickedImage = File(picked.path);
      });

      final url =
          await context.read<ProfileCubit>().uploadProfilePicture(pickedImage!);
      if (url != null) {
        setState(() {
          profileImageUrl = url;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final profile = ProfileModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      address: addressController.text,
      bio: bioController.text,
      profilePictureUrl: profileImageUrl,
    );
    context.read<ProfileCubit>().updateOrCreateProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('Edit Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileSuccess) {
            final profile = state.profile;
            final token = widget.token;
            if (profile.userType == 'merchant') {
              final freshProfile = await context
                  .read<ProfileCubit>()
                  .getMerchantProfile(profile.id!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: MerchantProfileScreen(
                        profile: freshProfile, token: token),
                  ),
                ),
              );
            } else {
              final freshProfile = await context
                  .read<ProfileCubit>()
                  .getUserProfile(profile.id!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: UserProfileScreen(profile: freshProfile),
                  ),
                ),
              );
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar with edit icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: pickedImage != null
                            ? FileImage(pickedImage!)
                            : (profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? NetworkImage(profileImageUrl!)
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit,
                                color: kPrimaryColor, size: 20),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'First name required'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: "Last Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Last name required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value != null && value.length < 6
                        ? 'Password too short'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Phone
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("phone",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Phone required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Address
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your address",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Your address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: Icon(Icons.location_on_outlined,
                          color: kPrimaryColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Address required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Bio
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Describe your page",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Describe your page",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Bio required' : null,
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state is ProfileLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: state is ProfileLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Done',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state is ProfileLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Color(0xFFD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
