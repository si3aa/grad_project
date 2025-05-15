import 'dart:convert';
import 'package:Herfa/ui/screens/home/add_new_post/data/data_source/api_respose.dart';
import 'package:Herfa/ui/screens/home/add_new_post/data/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import '../states/new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostState());

  void addImage(String imagePath) {
    final updatedImages = List<String>.from(state.images)..add(imagePath);
    emit(state.copyWith(images: updatedImages));
    print("Image added: $imagePath - Total images: ${state.images.length}");
  }

  void deleteImage(String imagePath) {
    final updatedImages = List<String>.from(state.images)..remove(imagePath);
    emit(state.copyWith(images: updatedImages));
    print("Image deleted: $imagePath - Total images: ${state.images.length}");
  }

  void updateProductName(String name) {
    emit(state.copyWith(productName: name));
    _printCurrentState("Product Name updated");
  }

  void updateProductTitle(String title) {
    emit(state.copyWith(productTitle: title));
    _printCurrentState("Product Title updated");
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
    _printCurrentState("Description updated");
  }

  void updatePrice(double price) {
    emit(state.copyWith(price: price));
    _printCurrentState("Price updated");
  }

  void updateQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
    _printCurrentState("Quantity updated");
  }

  void updateCategoryId(int categoryId) {
    emit(state.copyWith(categoryId: categoryId));
    _printCurrentState("Category ID updated");
  }

  void toggleColor(Color color, String colorName) {
    final updatedColors = List<Color>.from(state.selectedColors);
    final updatedColorNames = List<String>.from(state.selectedColorNames ?? []);

    if (updatedColors.contains(color)) {
      updatedColors.remove(color);
      updatedColorNames.remove(colorName);
    } else {
      updatedColors.add(color);
      updatedColorNames.add(colorName);
    }

    emit(state.copyWith(
      selectedColors: updatedColors,
      selectedColorNames: updatedColorNames,
    ));
    print("Color toggled: $colorName - Selected colors: ${state.selectedColorNames}");
  }

  Future<bool> submitProduct() async {
    // Validate required fields
    if (state.images.isEmpty) {
      emit(state.copyWith(error: 'Please add at least one product image'));
      print("Validation Error: No images provided");
      return false;
    }

    if (state.productName.isEmpty ||
        state.productTitle.isEmpty ||
        state.description.isEmpty ||
        state.price <= 0 ||
        state.quantity <= 0 ||
        state.categoryId <= 0 ||
        state.selectedColors.isEmpty) {
      emit(state.copyWith(
          error: 'Please fill all required fields and select at least one color'));
      print("Validation Error: Missing required fields");
      print("Product Name: ${state.productName.isEmpty ? 'MISSING' : 'OK'}");
      print("Product Title: ${state.productTitle.isEmpty ? 'MISSING' : 'OK'}");
      print("Description: ${state.description.isEmpty ? 'MISSING' : 'OK'}");
      print("Price: ${state.price <= 0 ? 'MISSING' : 'OK'}");
      print("Quantity: ${state.quantity <= 0 ? 'MISSING' : 'OK'}");
      print("Category ID: ${state.categoryId <= 0 ? 'MISSING' : 'OK'}");
      print("Colors: ${state.selectedColors.isEmpty ? 'MISSING' : 'OK'}");
      return false;
    }

    try {
      emit(state.copyWith(isLoading: true, error: null));

      final product = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.productName.trim(),
        title: state.productTitle.trim(),
        description: state.description.trim(),
        price: state.price,
        quantity: state.quantity,
        categoryId: state.categoryId,
        isActive: true,
        colors: state.selectedColorNames ?? [],
        images: state.images,
      );

      // Print product data for debugging
      print('======= SUBMITTING PRODUCT DATA =======');
      print('Product ID: ${product.id}');
      print('Product Name: ${product.name}');
      print('Product Title: ${product.title}');
      print('Description: ${product.description}');
      print('Price: ${product.price}');
      print('Quantity: ${product.quantity}');
      print('Category ID: ${product.categoryId}');
      print('Colors: ${product.colors}');
      print('Images: ${product.images}');
      print('======================================');

      // Send data to API
      final response = await sendProductToApi(product);

      // Print API response for debugging
      print('API response success: ${response.success}');
      print('API response message: ${response.message}');
      if (response.data != null) {
        print('API response data: ${response.data}');
      }

      if (!response.success) {
        throw Exception(response.message);
      }

      emit(state.copyWith(isLoading: false, error: null));
      return true;
    } catch (e) {
      print('Error in submitProduct: ${e.toString()}');
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return false;
    }
  }

  void resetState() {
    emit(NewPostState());
  }

  // Method to send product data to API
  Future<ApiResponse> sendProductToApi(ProductModel product) async {
    try {
      const String apiUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products';

      // Create a Dio instance
      final dio = Dio(BaseOptions(
        baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

      // Convert all product fields to strings
      final productData = {
        'id': product.id,
        'name': product.name,
        'title': product.title,
        'description': product.description,
        'price': product.price.toString(),
        'quantity': product.quantity.toString(),
        'categoryId': product.categoryId.toString(),
        'isActive': product.isActive.toString(),
        'colors': jsonEncode(product.colors),
      };

      // Create FormData for multipart request
      final formData = FormData.fromMap({
        'product_data': jsonEncode(productData),
        ...await Future.wait(
          product.images.asMap().entries.map((entry) async {
            final index = entry.key;
            final image = entry.value;
            return MapEntry(
              'image_$index',
              await MultipartFile.fromFile(image),
            );
          }),
        ).then((entries) => Map.fromEntries(entries)),
      });

      // Print request data to console
      print('Sending product data to API:');
      print('URL: $apiUrl');
      print('FormData: product_data=${jsonEncode(productData)}');
      for (var i = 0; i < product.images.length; i++) {
        print('FormData: image_$i=${product.images[i]}');
      }

      // Make the API call using Dio
      final response = await dio.post(
        '/products',
        data: formData,
        options: Options(
          validateStatus: (status) => true,
          followRedirects: false,
        ),
      );

      // Print response to console
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Attempt to parse response data as JSON
        final responseData = response.data is Map<String, dynamic>
            ? response.data
            : {'productId': product.id};
        return ApiResponse(
          success: true,
          message: 'Product created successfully',
          data: responseData,
        );
      } else {
        final errorMessage = response.data is Map<String, dynamic>
            ? response.data['message'] ?? 'Failed to create product'
            : 'Failed to create product: ${response.statusCode}';
        return ApiResponse(
          success: false,
          message: errorMessage,
        );
      }
    } catch (e) {
      // Print error to console
      print('Error sending product to API: ${e.toString()}');
      if (e is DioException) {
        print('Dio error type: ${e.type}');
        print('Dio error message: ${e.message}');
        if (e.response != null) {
          print('Dio error response: ${e.response?.data}');
        }
      }

      return ApiResponse(
        success: false,
        message: 'Error sending product to API: ${e.toString()}',
      );
    }
  }

  // Helper method to print current state
  void _printCurrentState(String action) {
    print("=== $action ===");
    print("Product Name: ${state.productName}");
    print("Product Title: ${state.productTitle}");
    print("Description: ${state.description}");
    print("Price: ${state.price}");
    print("Quantity: ${state.quantity}");
    print("Category ID: ${state.categoryId}");
    print("Selected Colors: ${state.selectedColorNames}");
    print("Images Count: ${state.images.length}");
    print("====================");
  }
}