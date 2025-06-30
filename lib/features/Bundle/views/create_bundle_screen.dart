import 'package:Herfa/core/constants/colors.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_selection_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/get_me/current_user_cubit.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateBundleScreen extends StatefulWidget {
  const CreateBundleScreen({Key? key}) : super(key: key);

  @override
  State<CreateBundleScreen> createState() => _CreateBundleScreenState();
}

class _CreateBundleScreenState extends State<CreateBundleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _products = [
    {'productId': '', 'quantity': ''},
  ];

  String? _token;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addProduct() {
    setState(() {
      _products.add({'productId': '', 'quantity': ''});
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  Future<String> getToken() async {
    if (_token != null) return _token!;
    final token = await _authDataSource.getToken();
    _token = token ?? '';
    return _token!;
  }

  Future<void> _selectProduct(int idx, int merchantId, String token) async {
    final selected = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSelectionScreen(
          merchantId: merchantId,
          token: token,
          onProductSelected: (id, name) =>
              Navigator.of(context).pop({'id': id, 'name': name}),
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        _products[idx]['productId'] = selected['id'].toString();
        _products[idx]['productName'] = selected['name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        int? merchantId;
        if (state is CurrentUserLoaded) {
          merchantId = state.user.id;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Bundle'),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: const Color(0xFFF7F8FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bundle Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.title),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter description'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Bundle Price',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter price'
                            : null,
                      ),
                      const SizedBox(height: 28),
                      const Text('Products',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 10),
                      ..._products.asMap().entries.map((entry) {
                        int idx = entry.key;
                        final quantity =
                            int.tryParse(_products[idx]['quantity'] ?? '1') ??
                                1;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: merchantId != null
                                        ? () async {
                                            final token = await getToken();
                                            await _selectProduct(
                                                idx, merchantId!, token);
                                          }
                                        : null,
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Product',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Color(0xFFF3F3F3),
                                        ),
                                        controller: TextEditingController(
                                          text: _products[idx]['productName'] !=
                                                      null &&
                                                  _products[idx]['productId'] !=
                                                      null
                                              ? '${_products[idx]['productName']} (ID: ${_products[idx]['productId']})'
                                              : (_products[idx]
                                                      ['productName'] ??
                                                  ''),
                                        ),
                                        validator: (val) =>
                                            val == null || val.isEmpty
                                                ? 'Select a product'
                                                : null,
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        splashRadius: 18,
                                        onPressed: quantity > 1
                                            ? () {
                                                setState(() {
                                                  _products[idx]['quantity'] =
                                                      (quantity - 1).toString();
                                                });
                                              }
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        splashRadius: 18,
                                        onPressed: () {
                                          setState(() {
                                            _products[idx]['quantity'] =
                                                (quantity + 1).toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: _products.length > 1
                                      ? () => _removeProduct(idx)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addProduct,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: merchantId != null
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    final token = await getToken();
                                    final bundleData = {
                                      'name': _nameController.text,
                                      'description':
                                          _descriptionController.text,
                                      'bundlePrice': double.tryParse(
                                              _priceController.text) ??
                                          0,
                                      'merchantId': merchantId,
                                      'products': _products
                                          .where((p) =>
                                              p['productId'] != null &&
                                              p['productId']
                                                  .toString()
                                                  .isNotEmpty)
                                          .map((p) => {
                                                'productId': int.tryParse(
                                                        p['productId'] ??
                                                            '0') ??
                                                    0,
                                                'quantity': int.tryParse(
                                                        p['quantity'] ?? '1') ??
                                                    1,
                                              })
                                          .toList(),
                                    };
                                    final response = await http.post(
                                      Uri.parse(
                                          'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/bundles'),
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': 'Bearer $token',
                                      },
                                      body: jsonEncode(bundleData),
                                    );
                                    if (response.statusCode == 200) {
                                      Navigator.of(context).pop(true);
                                    }
                                  }
                                }
                              : null,
                          label: const Text('Create Bundle'),
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
}
