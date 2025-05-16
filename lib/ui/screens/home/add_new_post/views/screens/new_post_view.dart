import 'package:Herfa/ui/screens/home/add_new_post/data/models/post_model.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/cubit/new_post_cubit.dart';
import 'package:Herfa/ui/screens/home/add_new_post/views/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/core/constants/colors.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';
import 'package:Herfa/ui/screens/home/add_new_post/views/widgets/image_picker.dart';
import 'package:Herfa/ui/screens/home/add_new_post/views/widgets/new_post_form_fields.dart';

// View for creating a new product post
class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Clothing'},
    {'id': 2, 'name': 'Accessories'},
    {'id': 3, 'name': 'Home Decor'},
    {'id': 4, 'name': 'Art'},
    {'id': 5, 'name': 'Handmade'},
  ];

  final List<Map<String, dynamic>> _colorOptions = [
    {'color': Colors.red, 'name': 'Red'},
    {'color': Colors.blue, 'name': 'Blue'},
    {'color': Colors.green, 'name': 'Green'},
    {'color': Colors.yellow, 'name': 'Yellow'},
    {'color': Colors.purple, 'name': 'Purple'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for form fade-in
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Sync controllers with initial state
    final state = context.read<NewPostCubit>().state;
    _productNameController.text = state.productName;
    _productTitleController.text = state.productTitle;
    _descriptionController.text = state.description;
    _priceController.text = state.price > 0 ? state.price.toString() : '';
    _quantityController.text = state.quantity > 0 ? state.quantity.toString() : '';
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productTitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _animationController.dispose();
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
            child: FadeTransition(
              opacity: _fadeAnimation,
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
                        onAddImage: (imagePath) => cubit.addImage(imagePath),
                        onDeleteImage: (imagePath) => cubit.deleteImage(imagePath),
                        maxImages: 5,
                      ),
                      if (state.images.isEmpty && _formKey.currentState?.validate() == false)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please add at least one product image',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Product Details Section
                      const Text(
                        'Product Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Product Name
                      TextFormField(
                        controller: _productNameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.shopping_bag_outlined),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          if (value.length < 3) {
                            return 'Product name must be at least 3 characters';
                          }
                          return null;
                        },
                        onChanged: (value) => cubit.updateProductName(value),
                      ),
                      const SizedBox(height: 16),

                      // Product Title
                      TextFormField(
                        controller: _productTitleController,
                        decoration: InputDecoration(
                          labelText: 'Product Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.title),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product title';
                          }
                          if (value.length < 5) {
                            return 'Product title must be at least 5 characters';
                          }
                          return null;
                        },
                        onChanged: (value) => cubit.updateProductTitle(value),
                      ),
                      const SizedBox(height: 16),

                      // Product Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Product Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(500),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product description';
                          }
                          if (value.length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                        onChanged: (value) => cubit.updateDescription(value),
                      ),
                      const SizedBox(height: 16),

                      // Price and Quantity in a row for larger screens
                      isSmallScreen
                          ? Column(
                              children: [
                                NewPostFormFields.buildPriceField(context, _priceController),
                                const SizedBox(height: 16),
                                NewPostFormFields.buildQuantityField(context, _quantityController),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: NewPostFormFields.buildPriceField(context, _priceController)),
                                const SizedBox(width: 16),
                                Expanded(child: NewPostFormFields.buildQuantityField(context, _quantityController)),
                              ],
                            ),
                      const SizedBox(height: 24),

                      // Category Selection
                      const Text(
                        'Select Category',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = state.categoryId == category['id'];

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(category['name']!),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    cubit.updateCategoryId(category['id']!);
                                  }
                                },
                                backgroundColor: Colors.grey[200],
                                selectedColor: kPrimaryColor,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Color Selection
                      const Text(
                        'Select Colors',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _colorOptions.length,
                          itemBuilder: (context, index) {
                            final colorOption = _colorOptions[index];
                            final color = colorOption['color'] as Color;
                            final colorName = colorOption['name'] as String;
                            final isSelected = state.selectedColorNames.contains(colorName);

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  cubit.toggleColor(colorName);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Active Status Toggle
                      Row(
                        children: [
                          const Text(
                            'Active Status:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Switch(
                            value: state.isActive,
                            onChanged: (value) {
                              cubit.updateActiveStatus(value);
                            },
                            activeColor: kPrimaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Move SubmitButton to body, aligned at the bottom center
                      Center(
                        child: SubmitButton(
                          state: state,
                          formKey: _formKey,
                          isFormValid: _isFormValid(state),
                          onSubmit: () async {
                            // Validate images
                            if (state.images.isEmpty) {
                              _formKey.currentState?.validate();
                              return false;
                            }

                            // Validate category
                            if (state.categoryId == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a category'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return false;
                            }

                            if (_formKey.currentState!.validate()) {
                              final product = ProductModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: state.productName,
                                title: state.productTitle,
                                description: state.description,
                                price: state.price,
                                quantity: state.quantity,
                                categoryId: state.categoryId != 0 ? state.categoryId : 1,
                                colors: state.selectedColorNames,
                                images: state.images,
                                isActive: state.isActive,
                              );

                              final response = await cubit.submitProduct(product, _formKey);

                              if (response.success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Product created successfully')),
                                );
                                await Future.delayed(const Duration(milliseconds: 500));
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                }
                                return true;
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to create product: ${response.message}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                            return false;
                          },
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

  bool _isFormValid(NewPostState state) {
    return state.productName.isNotEmpty &&
        state.productTitle.isNotEmpty &&
        state.description.isNotEmpty &&
        state.price > 0 &&
        state.quantity > 0 &&
        state.categoryId != 0 &&
        state.images.isNotEmpty;
  }
}