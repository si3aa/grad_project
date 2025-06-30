import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/features/get_product/viewmodels/product_state.dart'
    as product_states;
import 'package:Herfa/features/event/data/repositories/event_repository.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/features/get_me/current_user_cubit.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

class EventProductsScreen extends StatefulWidget {
  final String eventId;

  const EventProductsScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<EventProductsScreen> createState() => _EventProductsScreenState();
}

class _EventProductsScreenState extends State<EventProductsScreen> {
  Set<int> addedProductIds = {};
  final EventRepository _eventRepository = EventRepository(
    dio: Dio(),
    authDataSource: AuthSharedPrefLocalDataSource(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<CurrentUserCubit>();
      Data? user;
      if (cubit.state is! CurrentUserLoaded) {
        await cubit.fetchCurrentUser();
      }
      if (cubit.state is CurrentUserLoaded) {
        user = (cubit.state as CurrentUserLoaded).user;
      }
      final userId = user?.id ?? 0;
      context.read<ProductCubit>().loadMerchantProducts(userId.toString());
      // Fetch products already added to this event
      await _fetchAddedProducts();
    });
  }

  Future<void> _fetchAddedProducts() async {
    try {
      final dio = Dio();
      final authDataSource = AuthSharedPrefLocalDataSource();
      final token = await authDataSource.getToken();
      if (token == null) return;
      dio.options.headers['Authorization'] = 'Bearer $token';
      final url =
          'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/events/${widget.eventId}/products';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> products;
        if (data is List) {
          products = data;
        } else if (data is Map && data['data'] != null) {
          products = data['data'];
        } else if (data is Map && data['products'] != null) {
          products = data['products'];
        } else {
          products = [];
        }
        setState(() {
          addedProductIds = products.map<int>((p) => p['id'] as int).toSet();
        });
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  Future<void> _addProductToEvent(int productId, String? userRole) async {
    if (userRole == 'USER') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to add products to events.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      print('=== Starting Add Product Process ===');
      print('Event ID: ${widget.eventId}');
      print('Product ID: $productId');

      final success = await _eventRepository.addProductToEvent(
        widget.eventId,
        productId.toString(),
      );

      print('Add Product Result: $success');

      if (success) {
        setState(() {
          addedProductIds.add(productId);
        });
        print('Product added successfully to UI state');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added to event successfully'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('Failed to add product to event');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add product to event'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('=== Error in Add Product Process ===');
      print('Event ID: ${widget.eventId}');
      print('Product ID: $productId');
      print('Error: $e');
      print('===================================');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        String? userRole;
        if (state is CurrentUserLoaded) {
          userRole = state.user.role;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Products'),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          body: BlocBuilder<ProductCubit, product_states.ProductState>(
            builder: (context, state) {
              if (state is product_states.ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is product_states.ProductError) {
                return Center(
                  child: Text(state.message),
                );
              }

              if (state is product_states.ProductLoaded) {
                // Filter out products already added to the event
                final productsToShow = state.products
                    .where((product) => !addedProductIds.contains(product.id))
                    .toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Your Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productsToShow.length,
                      itemBuilder: (context, index) {
                        final product = productsToShow[index];
                        // No need to check isAdded anymore, since filtered
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.productImage,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${product.originalPrice.toStringAsFixed(2)} EGP',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Add Button (only for non-USER roles)
                                if (userRole != 'USER')
                                  ElevatedButton(
                                    onPressed: () => _addProductToEvent(
                                        product.id, userRole),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }

              return const Center(
                child: Text('No products available'),
              );
            },
          ),
        );
      },
    );
  }
}
