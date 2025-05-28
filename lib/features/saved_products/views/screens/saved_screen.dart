import 'package:Herfa/constants.dart';
import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';
import 'package:Herfa/features/saved_products/viewmodels/states/saved_product_state.dart';
import 'package:Herfa/features/saved_products/views/widgets/saved_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch saved products with details when screen loads
    context.read<SavedProductCubit>().fetchSavedProductsWithDetails();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate to home screen when back button is pressed
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      color: kPrimaryColor,
                    ),
                    const Spacer(),
                    const Text(
                      "Saved Products",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<SavedProductCubit, SavedProductState>(
                      builder: (context, state) {
                        int itemCount = 0;
                        if (state is SavedProductDetailsLoaded) {
                          itemCount = state.productDetails.length;
                        }
                        return Text(
                          "$itemCount items",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Product List
              Expanded(
                child: BlocBuilder<SavedProductCubit, SavedProductState>(
                  builder: (context, state) {
                    if (state is SavedProductLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      );
                    } else if (state is SavedProductError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<SavedProductCubit>()
                                    .fetchSavedProductsWithDetails();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is SavedProductsEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bookmark_border,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No saved products found',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                              ),
                              child: const Text('Browse Products'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is SavedProductDetailsLoaded) {
                      final products = state.productDetails;
                      if (products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bookmark_border,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No saved products found',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                ),
                                child: const Text('Browse Products'),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<SavedProductCubit>()
                              .fetchSavedProductsWithDetails();
                        },
                        color: kPrimaryColor,
                        child: Column(
                          children: [
                            // Instruction text
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                'Swipe down to refresh. Tap on a product to view details. Tap the trash icon to remove from saved items.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Product list
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom:
                                      80.0, // Add bottom padding for navigation bar
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return SavedProductItemWidget(
                                    product: products[index],
                                    onRemove: () {
                                      // Remove the product and reload the list
                                      context
                                          .read<SavedProductCubit>()
                                          .removeSavedProduct(
                                              products[index].id);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Default state or other states
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
