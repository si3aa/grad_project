import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'viewmodels/cubit/product_cubit.dart';
import 'viewmodels/product_state.dart';

Future<int?> showProductSelectionDialog(BuildContext context, int merchantId, {required String token}) async {
  return showDialog<int>(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => ProductCubit()..fetchProducts(merchantId, token),
        child: Dialog(
          backgroundColor: const Color(0xFFF3EFF7),
          child: SizedBox(
            width: 350,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProductLoaded) {
                          if (state.products.isEmpty) {
                            return const Center(child: Text('No products found'));
                          }
                          return ListView.separated(
                            itemCount: state.products.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (product['image'] != null)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            product['image'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'] ?? '',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.right,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${product['price']}',
                                              style: const TextStyle(fontSize: 15, color: Color(0xFF9B8EC9)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF9B8EC9),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(product['id']);
                                        },
                                        child: const Text('Add'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is ProductError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
