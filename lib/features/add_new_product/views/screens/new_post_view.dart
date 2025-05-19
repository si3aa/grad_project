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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// The view for creating a new product post, displaying the form UI.
class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  // Category list with IDs (1-based indexing for simplicity)
  static const _categories = [
    {'id': 1, 'name': 'Clothing'},
    {'id': 2, 'name': 'Accessories'},
    {'id': 3, 'name': 'Home Decor'},
    {'id': 4, 'name': 'Art'},
    {'id': 5, 'name': 'Handmade'},
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
            title: const Text('Create New Product'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      errorText: state.error != null && state.error!.toLowerCase().contains('title') 
                          ? state.error 
                          : null,
                    ),
                    const SizedBox(height: 16),

                    DescriptionField(
                      controller: _descriptionController,
                      onChanged: cubit.updateDescription,
                      errorText: state.error != null && state.error!.toLowerCase().contains('description') 
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
                      onSubmit: cubit.submitProduct,
                      formKey: _formKey,
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
