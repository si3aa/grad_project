import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/cubit/new_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostFormFields {
  static Widget buildPriceField(BuildContext context, TextEditingController controller) {
    final cubit = context.read<NewPostCubit>();

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter price';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: (value) {
        cubit.updatePrice(double.tryParse(value) ?? 0);
      },
    );
  }

  static Widget buildQuantityField(BuildContext context, TextEditingController controller) {
    final cubit = context.read<NewPostCubit>();

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Quantity',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.inventory),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter quantity';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: (value) {
        cubit.updateQuantity(int.tryParse(value) ?? 0);
      },
    );
  }
}