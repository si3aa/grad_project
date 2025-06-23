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

import 'dart:io';
import 'package:image_picker/image_picker.dart' as img_picker;

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

                    // Show current image and new image field when in edit mode
                    if (widget.isEditMode && widget.product != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current Image Section
                          const Text(
                            'Current Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.product!.productImage
                                      .startsWith('http')
                                  ? Image.network(
                                      widget.product!.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      widget.product!.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(Change Image is required)',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // New Image Section
                          const Text(
                            'New Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade50,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add new product image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Show image picker options
                                    _showImagePickerOptions(context, cubit);
                                  },
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Choose Image'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Show selected new images
                          if (state.images.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                const Text(
                                  'Selected New Images:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.images.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(state.images[index]),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () => cubit.deleteImage(
                                                    state.images[index]),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )
                    else
                      // Original image picker for new products
                      ImagePickerWidget(
                        images: state.images,
                        onAddImage: cubit.addImage,
                        onDeleteImage: cubit.deleteImage,
                        maxImages: 5,
                      ),

                    if (state.error != null &&
                        state.images.isEmpty &&
                        !widget.isEditMode)
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

  void _showImagePickerOptions(BuildContext context, NewPostCubit cubit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, cubit, img_picker.ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, cubit, img_picker.ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, NewPostCubit cubit,
      img_picker.ImageSource source) async {
    try {
      final picker = img_picker.ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        cubit.addImage(pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
