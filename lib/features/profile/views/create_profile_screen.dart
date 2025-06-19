import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/profile_cubit.dart';
import '../data/models/merchant_profile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class CreateProfileScreen extends StatefulWidget {
  final String token;
  final MerchantProfile? profile;
  const CreateProfileScreen({Key? key, required this.token, this.profile})
      : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String address;
  late String bio;
  String? profilePictureUrl;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    firstName = widget.profile?.firstName ?? '';
    lastName = widget.profile?.lastName ?? '';
    phone = widget.profile?.phone ?? '';
    address = widget.profile?.address ?? '';
    bio = widget.profile?.bio ?? '';
    profilePictureUrl = widget.profile?.profilePictureUrl;
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        uploading = true;
      });
      final cubit = context.read<ProfileCubit>();
      try {
        print('Uploading file: ${File(picked.path).path}');
        print('File exists: ${await File(picked.path).exists()}');
        print('Token: ${widget.token}');
        final url =
            await cubit.uploadProfilePicture(widget.token, File(picked.path));
        if (url != null) {
          setState(() {
            profilePictureUrl = url;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      } on DioException catch (e) {
        print('DioException: ${e.message}');
        print('DioException response: ${e.response?.data}');
        rethrow;
      }
      setState(() {
        uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.profile != null;
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is ProfileInitial) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: Text(isUpdate
                    ? 'Profile updated successfully!'
                    : 'Profile created successfully!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            Navigator.pop(context, true);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: uploading
                          ? null
                          : (profilePictureUrl != null &&
                                  profilePictureUrl!.isNotEmpty
                              ? NetworkImage(profilePictureUrl!)
                              : const AssetImage('noprofile.png')
                                  as ImageProvider),
                      child:
                          uploading ? const CircularProgressIndicator() : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: uploading ? null : _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit,
                              color: Color(0xFFB39DDB), size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('First Name'),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: firstName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSaved: (v) => firstName = v ?? '',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Last Name'),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: lastName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSaved: (v) => lastName = v ?? '',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Phone'),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  hintText: '0999 234 5678',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (v) => phone = v ?? '',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Your address'),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: address,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: Icon(Icons.location_on_outlined,
                      color: Color(0xFFB39DDB)),
                ),
                onSaved: (v) => address = v ?? '',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Describe your page'),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: bio,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                maxLines: 3,
                onSaved: (v) => bio = v ?? '',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB39DDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          context.read<ProfileCubit>().createOrUpdateProfile(
                            widget.token,
                            {
                              'firstName': firstName,
                              'lastName': lastName,
                              'phone': phone,
                              'address': address,
                              'bio': bio,
                              if (profilePictureUrl != null)
                                'profilePictureUrl': profilePictureUrl,
                            },
                          );
                        }
                      },
                      child: const Text('Done',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
