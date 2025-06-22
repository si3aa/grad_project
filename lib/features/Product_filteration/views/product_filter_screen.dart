import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_filter_repository.dart';
import '../viewmodels/product_filter_cubit.dart';

class ProductFilterScreen extends StatelessWidget {
  const ProductFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFilterCubit(ProductFilterRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Filteration')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProductFilterCubit>().fetchProducts(1),
                  child: const Text('Accessories'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProductFilterCubit>().fetchProducts(2),
                  child: const Text('Handmade'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProductFilterCubit>().fetchProducts(3),
                  child: const Text('Art'),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<ProductFilterCubit, ProductFilterState>(
                builder: (context, state) {
                  if (state is ProductFilterLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductFilterLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ListTile(
                          title: Text(product['name'] ?? 'No Name'),
                          subtitle: Text(product['description'] ?? ''),
                        );
                      },
                    );
                  } else if (state is ProductFilterError) {
                    return Center(child: Text('Error: \\${state.message}'));
                  }
                  return const Center(
                      child: Text('Select a category to filter products.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
