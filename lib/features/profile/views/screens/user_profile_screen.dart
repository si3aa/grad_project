import 'package:flutter/material.dart';
import '../../data/models/profile_model.dart';

class UserProfileScreen extends StatelessWidget {
  final ProfileModel profile;
  const UserProfileScreen({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profile.profilePictureUrl ?? ""),
            ),
            const SizedBox(height: 8),
            Text(
              '${profile.firstName ?? ""} ${profile.lastName ?? ""}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (profile.bio != null)
              Text(profile.bio!, style: const TextStyle(color: Colors.grey)),
            if (profile.phone != null)
              Text('Phone: ${profile.phone!}',
                  style: const TextStyle(color: Colors.grey)),
            if (profile.address != null)
              Text('Address: ${profile.address!}',
                  style: const TextStyle(color: Colors.grey)),
          
            // Add more fields as needed from the user API response
          ],
        ),
      ),
    );
  }
}
