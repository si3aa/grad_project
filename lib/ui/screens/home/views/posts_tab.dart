import 'package:Herfa/constants.dart';
import 'package:Herfa/features/get_product/views/product_card.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/features/get_product/viewmodels/product_state.dart';
import 'package:Herfa/features/favorites/viewmodels/favorite_cubit.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:Herfa/features/profile/data/repository/profile_repository.dart';
import 'package:Herfa/features/profile/viewmodels/profile_cubit.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return BlocProvider(
          create: (context) => FavoriteCubit(
            dio: Dio(),
            authLocalDataSource: AuthSharedPrefLocalDataSource(),
            prefs: snapshot.data!,
          ),
          child: BlocProvider(
            create: (context) => ProfileCubit(
              ProfileRepository(ProfileRemoteDataSource()),
            ),
            child: Scaffold(
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ProductCubit>().loadProducts();
                  },
                  color: kPrimaryColor,
                  child: ListView(
                    children: [
                      const HomeAppBar(),
                      const SizedBox(height: 20),
                      _SearchBar(),
                      const SizedBox(height: 20),
                      const CategoriesList(),
                      const SizedBox(height: 20),
                      _buildProductList(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Swipe down to refresh products',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          final products = state.filteredProducts;
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onCart: () {
                  context.read<ProductCubit>().addToCart(product);
                },
                onMore: (context) {
                  context.read<ProductCubit>().moreOptions(product, context);
                },
              );
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          onChanged: (value) {
            context.read<ProductCubit>().filterProducts(value);
          },
          decoration: const InputDecoration(
            hintText: "Search for anything on Herfa",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
