import 'dart:io';
import 'package:Herfa/core/widgets/back_to_home_button.dart';
import 'package:Herfa/features/add_new_product/viewmodels/cubit/new_post_viewmodel.dart';
import 'package:Herfa/features/add_new_product/viewmodels/states/new_post_state.dart';
import 'package:Herfa/features/add_new_product/views/widgets/active_status.dart';
import 'package:Herfa/features/add_new_product/views/widgets/category_selection.dart';
import 'package:Herfa/features/add_new_product/views/widgets/color_selection.dart';
import 'package:Herfa/features/add_new_product/views/widgets/description_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/price_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/product_name_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/product_title_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/quantity_field.dart';
import 'package:Herfa/features/add_new_product/views/widgets/submit_button.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

/// Dedicated screen for editing existing products
class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productNameController;
  late final TextEditingController _productTitleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  // Category list with IDs
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
    _productNameController =
        TextEditingController(text: widget.product.productName);
    _productTitleController = TextEditingController(text: widget.product.title);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.originalPrice.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
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

    return BlocProvider(
      create: (context) {
        final cubit = NewPostCubit();
        cubit.initWithProductData(widget.product);
        return cubit;
      },
      child: BlocBuilder<NewPostCubit, NewPostState>(
        builder: (context, state) {
          final cubit = context.read<NewPostCubit>();

          return Scaffold(
            appBar: AppBar(
              leading: const BackToHomeButton(),
              title: const Text('Edit Product'),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Show current image
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
                          child: _buildCurrentImage(),
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
                      if (state.images.isEmpty) ...[
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
                      ],

                      // Show selected new images (only if any)
                      if (state.images.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const Text(
                              'Selected New Image:',
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
                                  final imagePath = state.images[index];
                                  final file = File(imagePath);
                                  if (!file.existsSync()) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                                Icons.broken_image,
                                                size: 30,
                                                color: Colors.grey),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  cubit.deleteImage(imagePath),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
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
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: _buildImagePreview(imagePath),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () =>
                                                cubit.deleteImage(imagePath),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                state.error!
                                    .toLowerCase()
                                    .contains('description')
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
                        onSubmit: cubit.updateProduct,
                        formKey: _formKey,
                        isEditMode: true,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentImage() {
    final imageUrl = widget.product.productImage;

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      // For any other case, show a placeholder
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      );
    }
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

      if (!mounted) return;

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (await file.exists()) {
          if (!mounted) return;
          cubit.addImage(pickedFile.path);
        } else {
          if (!mounted) return;
        }
      }
    } catch (e) {
      if (!mounted) return;
    }
  }

  // Add this helper method to handle image preview safely
  Widget _buildImagePreview(String imagePath) {
    try {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child:
                  const Icon(Icons.broken_image, size: 30, color: Colors.grey),
            );
          },
        );
      } else {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
        );
      }
    } catch (e) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
      );
    }
  }
}
