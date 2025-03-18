import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/new_post_cubit.dart';
import 'package:Herfa/ui/widgets/home/image_picker.dart';
import 'package:Herfa/ui/widgets/home/product_specifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/home/custom_text_field.dart';
class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _materialController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  final _colorController = TextEditingController();
  final _shippingDetailsController = TextEditingController();
  final _shippingPriceController = TextEditingController();
  final _returnPolicyController = TextEditingController();
  final _paymentMethodsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NewPostCubit>().initializeDefaults();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _materialController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    _colorController.dispose();
    _shippingDetailsController.dispose();
    _shippingPriceController.dispose();
    _returnPolicyController.dispose();
    _paymentMethodsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                      color: kPrimaryColor,
                    ),
                    const Text(
                      "New post",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "You can add more images to your product :-",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                BlocBuilder<NewPostCubit, NewPostState>(
                  builder: (context, state) {
                    return ImagePickerWidget(
                      images: state.images,
                      onAddImage: (imagePath) => context.read<NewPostCubit>().addImage(imagePath),
                    );
                  },
                ),
                HomeCustomTextField(
                  label: "Product Name",
                  controller: _productNameController,
                  onChanged: (value) => context.read<NewPostCubit>().updateProductName(value),
                ),
                HomeCustomTextField(
                  label: "Product Description",
                  controller: _descriptionController,
                  maxLines: 2,
                  onChanged: (value) => context.read<NewPostCubit>().updateDescription(value),
                ),
                ProductSpecifications(
                  materialController: _materialController,
                  sizeController: _sizeController,
                  priceController: _priceController,
                  colorController: _colorController,
                ),
                HomeCustomTextField(
                  label: "Return Policy",
                  controller: _returnPolicyController,
                  maxLines: 2,
                  onChanged: (value) => context.read<NewPostCubit>().updateAdditionalInfo(returnPolicy: value),
                ),
                HomeCustomTextField(
                  label: "Payment Methods",
                  controller: _paymentMethodsController,
                  maxLines: 2,
                  onChanged: (value) => context.read<NewPostCubit>().updateAdditionalInfo(paymentMethods: value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
