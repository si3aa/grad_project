// ignore_for_file: deprecated_member_use

import 'package:Herfa/constants.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/event/data/repositories/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/get_me/current_user_cubit.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

class EventProductsListScreen extends StatefulWidget {
  final String eventId;

  const EventProductsListScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<EventProductsListScreen> createState() =>
      _EventProductsListScreenState();
}

class _EventProductsListScreenState extends State<EventProductsListScreen> {
  final Dio _dio = Dio();
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();
  final EventRepository _eventRepository;
  final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;

  _EventProductsListScreenState()
      : _eventRepository = EventRepository(
          dio: Dio(),
          authDataSource: AuthSharedPrefLocalDataSource(),
        );

  @override
  void initState() {
    super.initState();
    _loadEventProducts();
  }

  Future<void> _loadEventProducts() async {
    try {
      print('=== Loading Event Products ===');
      print('Event ID: ${widget.eventId}');

      final token = await _authDataSource.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      print('Request URL: $_baseUrl/events/${widget.eventId}/products');
      print('Headers: ${_dio.options.headers}');

      final response =
          await _dio.get('$_baseUrl/events/${widget.eventId}/products');

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        setState(() {
          if (response.data is List) {
            _products = response.data;
          } else if (response.data is Map && response.data['data'] != null) {
            _products = response.data['data'];
          } else if (response.data is Map &&
              response.data['products'] != null) {
            _products = response.data['products'];
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('=== Error Loading Event Products ===');
      print('Error: $e');
      if (e is DioException) {
        print('Dio Error Type: ${e.type}');
        print('Dio Error Message: ${e.message}');
        if (e.response != null) {
          print('Error Response Status: ${e.response?.statusCode}');
          print('Error Response Data: ${e.response?.data}');
        }
      }
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeProduct(String productId) async {
    try {
      print('\n=== Starting Product Removal Process ===');
      print('Event ID: ${widget.eventId}');
      print('Product ID: $productId');

      final success = await _eventRepository.removeProductFromEvent(
        widget.eventId,
        productId,
      );

      print('\n=== Product Removal Result ===');
      print('Success: $success');

      if (success) {
        // Remove the product from the local list
        setState(() {
          _products
              .removeWhere((product) => product['id'].toString() == productId);
        });
        print('Product removed from local list');
        print('Remaining products: ${_products.length}');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product removed from event'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      print('=== End Product Removal Process ===\n');
    } catch (e) {
      print('\n=== Error in Product Removal Process ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('=== End Error Details ===\n');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove product: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(String productId, String productName) {
    print('\n=== Showing Delete Confirmation ===');
    print('Product ID: $productId');
    print('Product Name: $productName');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Product'),
          content: Text(
            'Are you sure you want to remove "$productName" from this event?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Delete cancelled by user');
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Delete confirmed by user');
                Navigator.pop(context);
                _removeProduct(productId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
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
            title: const Text('Event Products'),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await _loadEventProducts();
            },
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Loading products...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)))
                    : _products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Products Yet',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add products to your event to get started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                if (userRole != 'USER')
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        '/event-products',
                                        arguments: {
                                          'eventId': widget.eventId,
                                        },
                                      );
                                      // Refresh the product list when returning from the Add Products screen
                                      await _loadEventProducts();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text(
                                      'Add Products',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              final productId = product['id'].toString();
                              final productName = product['productName'] ??
                                  product['name'] ??
                                  'Unknown Product';
                              final productImage = product['productImage'] ??
                                  product['media'] ??
                                  '';
                              final productPrice = (product['originalPrice'] ??
                                      product['price'] ??
                                      0)
                                  .toStringAsFixed(2);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Colors.grey.shade50,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Product Image
                                        Hero(
                                          tag: 'product-$productId',
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                productImage,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 32,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
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
                                                productName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '\$$productPrice',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Delete Button
                                        if (userRole != 'USER')
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: IconButton(
                                              onPressed: () =>
                                                  _showDeleteConfirmation(
                                                productId,
                                                productName,
                                              ),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                              tooltip: 'Remove product',
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        );
      },
    );
  }
}
