import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_selection_dialog.dart';
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
  final AuthSharedPrefLocalDataSource _authDataSource = AuthSharedPrefLocalDataSource();

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

  int getMerchantId() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return userViewModel.userId ?? 0;
  }

  Future<String> getToken() async {
    if (_token != null) return _token!;
    final token = await _authDataSource.getToken();
    _token = token ?? '';
    return _token!;
  }

  Future<void> _selectProduct(int idx) async {
    final merchantId = getMerchantId();
    final token = await getToken();
    final selectedId = await showProductSelectionDialog(context, merchantId, token: token);
    if (selectedId != null) {
      setState(() {
        _products[idx]['productId'] = selectedId.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bundle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Bundle Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 24),
              const Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._products.asMap().entries.map((entry) {
                int idx = entry.key;
                final quantity = int.tryParse(_products[idx]['quantity'] ?? '1') ?? 1;
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectProduct(idx),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Product ID'),
                            controller: TextEditingController(text: _products[idx]['productId']),
                            validator: (val) => val == null || val.isEmpty ? 'Enter product ID' : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: quantity > 1
                                ? () {
                                    setState(() {
                                      _products[idx]['quantity'] = (quantity - 1).toString();
                                    });
                                  }
                                : null,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: TextEditingController(text: quantity.toString()),
                              onChanged: (val) => _products[idx]['quantity'] = val,
                              validator: (val) => val == null || val.isEmpty ? 'Enter quantity' : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                _products[idx]['quantity'] = (quantity + 1).toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: _products.length > 1 ? () => _removeProduct(idx) : null,
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final merchantId = getMerchantId();
                    final token = await getToken();
                    final bundleData = {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'bundlePrice': double.tryParse(_priceController.text) ?? 0,
                      'merchantId': merchantId,
                      'products': _products
                          .where((p) => p['productId'] != null && p['productId'].toString().isNotEmpty)
                          .map((p) => {
                                'productId': int.tryParse(p['productId'] ?? '0') ?? 0,
                                'quantity': int.tryParse(p['quantity'] ?? '1') ?? 1,
                              })
                          .toList(),
                    };
                    print('Request: POST https://zygotic-marys-herfa-c2dd67a8.koyeb.app/bundles');
                    print('Body: ' + jsonEncode(bundleData));
                    final response = await http.post(
                      Uri.parse('https://zygotic-marys-herfa-c2dd67a8.koyeb.app/bundles'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode(bundleData),
                    );
                    print('Response: ${response.statusCode} ${response.body}');
                    // Optionally show a snackbar or dialog on success/failure
                  }
                },
                child: const Text('Create Bundle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

