import 'package:Herfa/ui/provider/cubit/search_cubit.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:Herfa/features/profile/data/repositories/profile_repository.dart';
import 'package:Herfa/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:Herfa/features/profile/data/repositories/merchant_profile_repository.dart';
import 'package:Herfa/features/profile/data/data_source/remote/merchant_profile_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  final String? token;
  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    developer.log('HomeScreen token: \x1B[32m${widget.token}\x1B[0m',
        name: 'HomeScreen');
    _fetchProfileName();
  }

  Future<void> _fetchProfileName() async {
    if (widget.token == null) return;
    try {
      final repo = ProfileRepository(ProfileRemoteDataSource(Dio()));
      final response = await repo.fetchProfile(widget.token!);
      if (response.success && response.data != null) {
        final profile = response.data!;
        setState(() {
          userName =
              ((profile.firstName ?? '') + ' ' + (profile.lastName ?? ''))
                  .trim();
        });
      }
    } catch (e) {
      developer.log('Failed to fetch profile name: $e', name: 'HomeScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  HomeAppBar(token: widget.token, userName: userName),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          return TextField(
                            decoration: InputDecoration(
                              hintText: "Search for anything on Herfa",
                              prefixIcon: const Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CategoriesList(),
                  NavBarWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
