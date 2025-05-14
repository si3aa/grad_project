import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/profile/data/repositories/merchant_profile_repository.dart';
import 'package:Herfa/features/profile/data/data_source/remote/merchant_profile_remote_data_source.dart';
import 'package:Herfa/features/profile/viewmodel/cubit/merchant_profile_cubit.dart';

import 'package:dio/dio.dart';
import 'package:Herfa/core/utils/image_utils.dart';

class MerchantProfileScreen extends StatelessWidget {
  final String? token;
  final int merchantId;
  const MerchantProfileScreen(
      {super.key, required this.token, required this.merchantId});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => MerchantProfileCubit(
        MerchantProfileRepository(MerchantProfileRemoteDataSource(Dio())),
      )..fetchMerchantProfile(token!, merchantId),
      child: BlocBuilder<MerchantProfileCubit, MerchantProfileState>(
        builder: (context, state) {
          if (state is MerchantProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is MerchantProfileError) {
            return Scaffold(
              body: Center(child: Text('Failed to load merchant profile.')),
            );
          }
          if (state is MerchantProfileLoaded) {
            final profile = state.profile;
            return Scaffold(
              appBar: AppBar(title: const Text('Merchant Profile')),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          getAppImageProvider(url: profile.profilePictureUrl),
                      child: (profile.profilePictureUrl == null ||
                              profile.profilePictureUrl!.isEmpty)
                          ? const Icon(Icons.person, size: 48)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${profile.firstName} ${profile.lastName}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(profile.phone,
                        style: const TextStyle(color: Colors.grey)),
                    Text(profile.address,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(profile.bio, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text('Average Rating: ${profile.averageRating}'),
                    Text('Number of Ratings: ${profile.numberOfRatings}'),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // TODO: Display products list here
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
