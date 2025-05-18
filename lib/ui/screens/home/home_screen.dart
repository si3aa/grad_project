import 'package:Herfa/ui/provider/cubit/search_cubit.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, String? token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    if (token == null || token!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('You are not logged in. Please log in.')),
      );
    }
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  HomeAppBar(token: token, userName: userName),
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
