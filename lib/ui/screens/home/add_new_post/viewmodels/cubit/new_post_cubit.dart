import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/ui/screens/home/add_new_post/data/models/post_model.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';

class SubmitResponse {
  final bool success;
  final String message;

  SubmitResponse({required this.success, required this.message});
}

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostState());

  void addImage(String imagePath) {
    final updatedImages = List<String>.from(state.images)..add(imagePath);
    emit(state.copyWith(images: updatedImages));
  }

  void deleteImage(String imagePath) {
    final updatedImages = state.images.where((img) => img != imagePath).toList();
    emit(state.copyWith(images: updatedImages));
  }

  void updateProductName(String value) {
    emit(state.copyWith(productName: value));
  }

  void updateProductTitle(String value) {
    emit(state.copyWith(productTitle: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void updatePrice(double value) {
    emit(state.copyWith(price: value));
  }

  void updateQuantity(int value) {
    emit(state.copyWith(quantity: value));
  }

  void updateCategoryId(int categoryId) {
    emit(state.copyWith(categoryId: categoryId));
  }

  void toggleColor(String colorName) {
    final colors = List<String>.from(state.selectedColorNames);
    if (colors.contains(colorName)) {
      colors.remove(colorName);
    } else {
      colors.add(colorName);
    }
    emit(state.copyWith(selectedColorNames: colors));
  }

  void updateActiveStatus(bool isActive) {
    emit(state.copyWith(isActive: isActive));
  }

  Future<SubmitResponse> submitProduct(ProductModel product, GlobalKey<FormState> formKey) async {
    emit(state.copyWith(isLoading: true, error: ''));
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (state.images.isNotEmpty) {
      emit(state.copyWith(isLoading: false));
      return SubmitResponse(success: true, message: 'Success');
    } else {
      emit(state.copyWith(isLoading: false, error: 'No images uploaded'));
      return SubmitResponse(success: false, message: 'No images uploaded');
    }
  }
}