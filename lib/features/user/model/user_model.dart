import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String role;
  final bool verified;
  final UserProfile? profile;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.verified,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      verified: json['verified'] as bool,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
    );
  }

  String get fullName {
    // Remove extra spaces and trim
    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();

    // Capitalize first letter of lastName
    final capitalizedLastName = cleanLastName.isNotEmpty
        ? '${cleanLastName[0].toUpperCase()}${cleanLastName.substring(1)}'
        : '';

    return '$cleanFirstName $capitalizedLastName'.trim();
  }

  @override
  String toString() {
    return '''
    ================ User Details ================
    ID: $id
    Username: $username
    Name: $fullName
    Role: $role
    Verified: $verified
    Profile Info: ${profile != null ? '\n      Name: ${profile!.firstName} ${profile!.lastName}\n      Phone: ${profile!.phone}\n      Address: ${profile!.address}\n      Bio: ${profile!.bio}' : 'No profile data'}
    ============================================
    ''';
  }
}

class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String bio;
  final String? profilePictureUrl;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.bio,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      bio: json['bio'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }
}

class UserViewModel with ChangeNotifier {
  late UserModel _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  int get userId => _user.id;
  String get username => _user.username;
  String get fullName => _user.fullName;
  String get userRole => _user.role;
  bool get isVerified => _user.verified;
  UserProfile? get profile => _user.profile;
}

class UserInfoDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Username: ${userViewModel.username}'),
        Text('Full Name: ${userViewModel.fullName}'),
        Text('User ID: ${userViewModel.userId}'),
        Text('Role: ${userViewModel.userRole}'),
        Text('Verified: ${userViewModel.isVerified}'),
        if (userViewModel.profile != null) ...{
          Text('Phone: ${userViewModel.profile!.phone}'),
          Text('Address: ${userViewModel.profile!.address}'),
          Text('Bio: ${userViewModel.profile!.bio}'),
          if (userViewModel.profile!.profilePictureUrl != null)
            Image.network(userViewModel.profile!.profilePictureUrl!),
        },
      ],
    );
  }
}
