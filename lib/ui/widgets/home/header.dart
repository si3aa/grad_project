import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/features/profile/viewmodels/profile_cubit.dart';
import 'package:Herfa/features/profile/views/merchant_profile_screen.dart';
import 'package:Herfa/features/profile/views/create_profile_screen.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'dart:developer';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String firstName = '';
        String lastName = '';
        String? photoUrl;
        if (state is ProfileLoaded) {
          firstName = state.profile.firstName;
          lastName = state.profile.lastName;
          photoUrl = state.profile.profilePictureUrl;
        }
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final token =
                        await AuthSharedPrefLocalDataSource().getToken();
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getInt('userId');
                    print('Token: $token');
                    print('userId from prefs: $userId');
                    if (token == null || userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Not authenticated!')),
                      );
                      return;
                    }
                    final cubit = context.read<ProfileCubit>();
                    await cubit.fetchProfile(token, userId);
                    final state = cubit.state;
                    if (state is ProfileLoaded) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MerchantProfileScreen(profile: state.profile),
                        ),
                      );
                    } else if (state is ProfileNotFound) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: CreateProfileScreen(token: token),
                          ),
                        ),
                      );
                    } else if (state is ProfileError) {
                      log('Profile error: \\${state.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : const AssetImage('noprofile.png') as ImageProvider,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome 👋",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      (state is ProfileLoaded)
                          ? "${state.profile.firstName} ${state.profile.lastName}"
                          : "User",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userId');
                    await AuthSharedPrefLocalDataSource().saveToken('');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully!')),
                    );
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "We have prepared new products for you",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ]);
      },
    );
  }
}
