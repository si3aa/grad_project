import 'package:Herfa/ui/provider/cubit/search_cubit.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                HomeAppBar(),
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
    );
  }
}