import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'viewmodels/cubit/product_cubit.dart';
import 'viewmodels/product_state.dart';

class ProductSelectionScreen extends StatelessWidget {
  final int merchantId;
  final String token;
  final void Function(int productId, String productName) onProductSelected;

  const ProductSelectionScreen({
    Key? key,
    required this.merchantId,
    required this.token,
    required this.onProductSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..fetchProducts(merchantId, token),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Product'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        backgroundColor: const Color(0xFFF3EFF7),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 32, thickness: 1, color: Color(0xFFE0E0E0)),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    Widget productImageWidget;
                    if (product['productImage'] != null &&
                        product['productImage'].toString().isNotEmpty) {
                      productImageWidget = Image.network(
                        product['productImage'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child:
                                const Icon(Icons.image_not_supported, size: 28),
                          );
                        },
                      );
                    } else if (product['media'] != null &&
                        product['media'].toString().isNotEmpty) {
                      productImageWidget = Image.network(
                        product['media'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child:
                                const Icon(Icons.image_not_supported, size: 28),
                          );
                        },
                      );
                    } else {
                      productImageWidget = Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 28),
                      );
                    }
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: productImageWidget,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3B2A5D),
                                      fontFamily: 'Cairo',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${product['price']}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF9B8EC9),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  if (product['description'] != null &&
                                      product['description']
                                          .toString()
                                          .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        product['description'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9B8EC9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo'),
                                  elevation: 1,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  onProductSelected(
                                      product['id'], product['name'] ?? '');
                                },
                                child: const Text('Add'),
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }
}
