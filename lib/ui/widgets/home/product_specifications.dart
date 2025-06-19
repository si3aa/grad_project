import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/ui/provider/cubit/new_post_cubit.dart';
import 'custom_text_field.dart';

class ProductSpecifications extends StatelessWidget {
  final TextEditingController materialController;
  final TextEditingController sizeController;
  final TextEditingController priceController;
  final TextEditingController colorController;

  const ProductSpecifications({
    super.key,
    required this.materialController,
    required this.sizeController,
    required this.priceController,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Specifications",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: HomeCustomTextField(
                label: "Material",
                controller: materialController,
                onChanged: (value) => context.read<NewPostCubit>().updateSpecifications(material: value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: HomeCustomTextField(
                label: "Size",
                keyboardType: TextInputType.number,
                controller: sizeController,
                onChanged: (value) => context.read<NewPostCubit>().updateSpecifications(size: value),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: HomeCustomTextField(
                label: "Price",
                controller: priceController,
                keyboardType: TextInputType.number,
                onChanged: (value) => context.read<NewPostCubit>().updateSpecifications(
                  price: value.isNotEmpty ? double.parse(value) : null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: HomeCustomTextField(
                label: "Color",
                controller: colorController,
                onChanged: (value) => context.read<NewPostCubit>().updateSpecifications(color: value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
