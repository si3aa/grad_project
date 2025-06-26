import 'package:Herfa/constants.dart';
import 'package:Herfa/features/get_product/views/product_card.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/features/favorites/viewmodels/favorite_cubit.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/Product_filteration/viewmodels/product_filter_cubit.dart';
import 'package:Herfa/features/Product_filteration/data/product_filter_repository.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/core/route_manger/routes.dart';

import '../../../../features/get_product/viewmodels/product_state.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FavoriteCubit(
                dio: Dio(),
                authLocalDataSource: AuthSharedPrefLocalDataSource(),
                prefs: snapshot.data!,
              ),
            ),
            BlocProvider(
              create: (context) =>
                  ProductFilterCubit(ProductFilterRepository()),
            ),
          ],
          child: _PostsTabContent(
            selectedCategoryId: selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                selectedCategoryId = categoryId;
              });
            },
          ),
        );
      },
    );
  }
}

class _PostsTabContent extends StatelessWidget {
  final int? selectedCategoryId;
  final void Function(int?) onCategorySelected;
  const _PostsTabContent(
      {Key? key,
      required this.selectedCategoryId,
      required this.onCategorySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedCategoryId == null) {
              await context.read<ProductCubit>().loadProducts();
            } else {
              await context
                  .read<ProductFilterCubit>()
                  .fetchProducts(selectedCategoryId!);
            }
          },
          color: kPrimaryColor,
          child: ListView(
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20),
              _SearchBar(),
              const SizedBox(height: 20),
              CategoriesList(
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: (categoryId) {
                  onCategorySelected(categoryId);
                  if (categoryId == null) {
                    context.read<ProductCubit>().loadProducts();
                  } else {
                    context
                        .read<ProductFilterCubit>()
                        .fetchProducts(categoryId);
                  }
                },
              ),
              const SizedBox(height: 20),
              // Bundle Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.amber.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.all_inbox, color: Colors.orange),
                    title: const Text('Bundle',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Check out our special bundles!'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.bundleRoute);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProductList(context),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }

  Widget _buildProductList(BuildContext context) {
    if (selectedCategoryId == null) {
      // Show all products
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
    } else {
      // Show filtered products
      return BlocBuilder<ProductFilterCubit, ProductFilterState>(
        builder: (context, state) {
          if (state is ProductFilterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductFilterLoaded) {
            print('Filtered products raw data: \\${state.products}');
            final products = state.products.map<Product>((json) {
              final product = _mapJsonToProduct(json);
              print(
                  'Mapped Product: id=\\${product.id}, name=\\${product.productName}');
              return product;
            }).toList();
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
                  onCart: () {}, // Implement if needed
                  onMore: (context) {}, // Implement if needed
                );
              },
            );
          } else if (state is ProductFilterError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      );
    }
  }

  Product _mapJsonToProduct(Map<String, dynamic> json) {
    print('Mapping JSON to Product: \\${json.toString()}');
    return Product(
      id: json['id'] ?? json['productId'] ?? 0,
      userId: json['userId'] ?? 0,
      userFirstName: json['userFirstName'] ?? json['firstName'] ?? '',
      userUsername: json['userUsername'] ?? json['username'] ?? '',
      userLastName: json['userLastName'] ?? json['lastName'] ?? '',
      userImage: json['userImage'] ??
          json['user_image'] ??
          json['image'] ??
          'assets/images/arrow-small-left.png',
      productImage: json['media'] ??
          json['productImage'] ??
          json['image'] ??
          json['product_image'] ??
          'assets/images/product_img.png',
      productName: json['productName'] ?? json['name'] ?? '',
      originalPrice: (json['originalPrice'] is int)
          ? (json['originalPrice'] as int).toDouble()
          : (json['originalPrice'] ?? json['price'] ?? 0.0),
      discountedPrice: (json['discountedPrice'] is int)
          ? (json['discountedPrice'] as int).toDouble()
          : (json['discountedPrice'] ?? json['discount'] ?? 0.0),
      title: json['title'] ?? json['productTitle'] ?? '',
      description: json['description'] ??
          json['desc'] ??
          json['shortDescription'] ??
          json['longDescription'] ??
          '',
      quantity: json['quantity'] ?? json['qty'] ?? 0,
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
