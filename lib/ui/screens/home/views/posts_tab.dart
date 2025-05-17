import 'package:Herfa/ui/screens/home/prduct/views/product_card.dart';
import 'package:Herfa/ui/screens/home/prduct/viewmodels/product_cubit.dart';
import 'package:Herfa/ui/screens/home/prduct/models/product_model.dart';
import 'package:Herfa/ui/widgets/home/header.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const HomeAppBar(),
                const SizedBox(height: 20),
                _SearchBar(),
                const SizedBox(height: 20),
                const CategoriesList(),
                const SizedBox(height: 20),
                _ProductList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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

class _ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onLike: () {
                  context.read<ProductCubit>().likeProduct(product);
                },
                onComment: () {
                  context.read<ProductCubit>().commentProduct(product);
                },
                onCart: () {
                  context.read<ProductCubit>().addToCart(product);
                },
                onMore: () {
                  context.read<ProductCubit>().moreOptions(product);
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
