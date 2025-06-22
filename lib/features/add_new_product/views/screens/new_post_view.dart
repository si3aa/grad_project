import 'package:Herfa/core/widgets/back_to_home_button.dart';
import 'package:Herfa/features/add_new_product/viewmodels/cubit/new_post_viewmodel.dart';
import 'package:Herfa/features/add_new_product/viewmodels/states/new_post_state.dart';
import 'package:Herfa/features/add_new_product/views/widgets/active_status.dart';
import 'package:Herfa/features/add_new_product/views/widgets/category_selection.dart';
import 'package:Herfa/features/add_new_product/views/widgets/color_selection.dart';
import 'package:Herfa/features/add_new_product/views/widgets/description_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/image_picker.dart';
import 'package:Herfa/features/add_new_product/views/widgets/price_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/product_name_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/product_title_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/quantity_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/submit_button.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

/// The view for creating a new product post, displaying the form UI.
class NewPostView extends StatefulWidget {
  final bool isEditMode;
  final Product? product;
  final int? productId;

  const NewPostView({
    Key? key,
    this.isEditMode = false,
    this.product,
    this.productId,
  }) : super(key: key);

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productNameController;
  late final TextEditingController _productTitleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  // Category list with IDs (1-based indexing for simplicity)
  static const _categories = [
    {'id': 1, 'name': 'Accessories'},
    {'id': 2, 'name': 'Handmade'},
    {'id': 3, 'name': 'Art'},
    {'id': 4, 'name': 'Clothing'},
    {'id': 5, 'name': 'Home Decore'},
  ];

  // Color options and their names
  static const _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  static final _colorNames = {
    Colors.red: 'Red',
    Colors.blue: 'Blue',
    Colors.green: 'Green',
    Colors.yellow: 'Yellow',
    Colors.purple: 'Purple',
  };

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _productTitleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();

    // Initialize with product data if in edit mode
    if (widget.isEditMode && widget.product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<NewPostCubit>();
        cubit.initWithProductData(widget.product!);

        // Set controller values
        _productNameController.text = widget.product!.productName;
        _productTitleController.text = widget.product!.title;
        _descriptionController.text = widget.product!.description;
        _priceController.text = widget.product!.originalPrice.toString();
        _quantityController.text = widget.product!.quantity.toString();
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productTitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return BlocBuilder<NewPostCubit, NewPostState>(
      builder: (context, state) {
        final cubit = context.read<NewPostCubit>();

        return Scaffold(
          appBar: AppBar(
            leading: const BackToHomeButton(),
            title: Text(widget.isEditMode ? 'Edit Product' : 'Add New Product'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Images Section
                    const Text(
                      'Product Images',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ImagePickerWidget(
                      images: state.images,
                      onAddImage: cubit.addImage,
                      onDeleteImage: cubit.deleteImage,
                      maxImages: 5,
                    ),
                    if (state.error != null && state.images.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Please add at least one product image',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Product Details Section
                    const Text(
                      'Product Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ProductNameField(
                      controller: _productNameController,
                      onChanged: cubit.updateProductName,
                    ),
                    const SizedBox(height: 16),

                    ProductTitleField(
                      controller: _productTitleController,
                      onChanged: cubit.updateProductTitle,
                      errorText: state.error != null &&
                              state.error!.toLowerCase().contains('title')
                          ? state.error
                          : null,
                    ),
                    const SizedBox(height: 16),

                    DescriptionField(
                      controller: _descriptionController,
                      onChanged: cubit.updateDescription,
                      errorText: state.error != null &&
                              state.error!.toLowerCase().contains('description')
                          ? state.error
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Price and Quantity
                    isSmallScreen
                        ? Column(
                            children: [
                              PriceField(
                                controller: _priceController,
                                onChanged: cubit.updatePrice,
                              ),
                              const SizedBox(height: 16),
                              QuantityField(
                                controller: _quantityController,
                                onChanged: cubit.updateQuantity,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: PriceField(
                                  controller: _priceController,
                                  onChanged: cubit.updatePrice,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: QuantityField(
                                  controller: _quantityController,
                                  onChanged: cubit.updateQuantity,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 24),

                    // Category Selection
                    CategorySelection(
                      state: state,
                      onCategorySelected: cubit.updateCategoryId,
                      categories: _categories,
                    ),
                    const SizedBox(height: 24),

                    // Color Selection
                    ColorSelection(
                      state: state,
                      onColorToggled: cubit.toggleColor,
                      colorOptions: _colorOptions,
                      colorNames: _colorNames,
                    ),
                    const SizedBox(height: 24),

                    // Active Status
                    const ActiveStatus(),
                    const SizedBox(height: 32),

                    // Submit Button
                    SubmitButton(
                      state: state,
                      onSubmit: widget.isEditMode
                          ? cubit.updateProduct
                          : cubit.submitProduct,
                      formKey: _formKey,
                      isEditMode: widget.isEditMode,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> updateProduct({
  required String productId,
  required String name,
  required String shortDescription,
  required String longDescription,
  required double price,
  required int quantity,
  required int categoryId,
  required String filePath, // Local path to the image file
  required bool active,
  required List<String> colors, // e.g. ['red', 'blue']
}) async {
  final dio = Dio();

  // Convert colors to JSON string
  final colorsJson =
      colors.toString(); // or jsonEncode(colors) if you import dart:convert

  // Print all data before sending
  print('--- Data to be sent for product update ---');
  print('product_id: $productId');
  print('name: $name');
  print('shortDescription: $shortDescription');
  print('longDescription: $longDescription');
  print('price: $price');
  print('quantity: $quantity');
  print('categoryId: $categoryId');
  print('filePath: $filePath');
  print('active: $active');
  print('colors: $colorsJson');
  print('------------------------------------------');

  final formData = FormData.fromMap({
    'name': name,
    'shortDescription': shortDescription,
    'longDescription': longDescription,
    'price': price.toString(),
    'quantity': quantity.toString(),
    'categoryId': categoryId.toString(),
    'file': await MultipartFile.fromFile(filePath),
    'product_id': productId,
    'active': active.toString(),
    'colors': colorsJson,
  });

  final response = await dio.put(
    'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products',
    data: formData,
    options: Options(
      headers: {
        'Authorization': 'Bearer YOUR_TOKEN',
        'Content-Type': 'multipart/form-data',
      },
    ),
  );

  print(response.data);
}
