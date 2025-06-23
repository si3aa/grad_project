import 'dart:developer';
import 'dart:io';
import 'package:Herfa/app_interceptors.dart';
import 'package:Herfa/app_strings.dart';
import 'package:Herfa/exceptions.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/status_codes.dart';
import 'package:Herfa/features/add_new_product/data/data_source/api_respose.dart';
import 'package:Herfa/features/add_new_product/data/models/post_model.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import '../states/new_post_state.dart';
import 'package:Herfa/features/get_product/data/repository/product_api_repository.dart';

class NewPostCubit extends Cubit<NewPostState> {
  final ProductApiRepository _productApiRepository = ProductApiRepository();
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
    String? error = state.error;
    // Clear the error if it was specifically about the title length
    if (error != null && error.contains('title must be at least')) {
      if (title.length >= 10) {
        error = null;
      }
    }
    emit(state.copyWith(productTitle: title, error: error));
  }

  void updateDescription(String description) {
    String? error = state.error;
    // Clear the error if it was specifically about the description length
    if (error != null && error.contains('description must be at least')) {
      if (description.length >= 20) {
        error = null;
      }
    }
    emit(state.copyWith(description: description, error: error));
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
    print(
        "Color toggled: $colorName - Selected colors: ${state.selectedColorNames}");
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
        state.productTitle.length < 10 ||
        state.description.isEmpty ||
        state.description.length < 20 ||
        state.price <= 0 ||
        state.quantity <= 0 ||
        state.categoryId <= 0 ||
        state.selectedColors.isEmpty) {
      String errorMessage =
          'Please fill all required fields and select at least one color';

      if (state.productTitle.isNotEmpty && state.productTitle.length < 10) {
        errorMessage = 'Product title must be at least 10 characters';
      } else if (state.description.isNotEmpty &&
          state.description.length < 20) {
        errorMessage = 'Product description must be at least 20 characters';
      }

      emit(state.copyWith(error: errorMessage));

      print("Validation Error: Missing required fields or length requirements");
      print("Product Name: ${state.productName.isEmpty ? 'MISSING' : 'OK'}");
      print(
          "Product Title: ${state.productTitle.isEmpty ? 'MISSING' : (state.productTitle.length < 10 ? 'TOO SHORT' : 'OK')}");
      print(
          "Description: ${state.description.isEmpty ? 'MISSING' : (state.description.length < 20 ? 'TOO SHORT' : 'OK')}");
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
        String errorMessage = response.message;
        if (errorMessage.contains('401') ||
            errorMessage.contains('Unauthorized')) {
          errorMessage =
              'Authentication failed. Please check your login status.';
        } else if (errorMessage.contains('404')) {
          errorMessage =
              'API endpoint not found. Please check the server configuration.';
        } else if (errorMessage.contains('500')) {
          errorMessage = 'Server error occurred. Please try again later.';
        }
        throw Exception(errorMessage);
      }

      emit(state.copyWith(isLoading: false, error: null));
      return true;
    } catch (e) {
      print('Error in submitProduct: ${e.toString()}');
      String errorMessage = e.toString();
      if (e is DioException) {
        print('DioError details:');
        print('Error type: ${e.type}');
        print('Error message: ${e.message}');
        print('Error response: ${e.response?.data}');
        print('Error status code: ${e.response?.statusCode}');

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.unknown) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (e.response?.statusCode == 401) {
          errorMessage =
              'Authentication failed. Please check your login status.';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Product not found. Please check the product ID.';
        } else if (e.response?.statusCode == 500) {
          errorMessage = 'Server error occurred. Please try again later.';
        }
      }
      emit(state.copyWith(isLoading: false, error: errorMessage));
      return false;
    }
  }

  void resetState() {
    emit(NewPostState());
  }

  void setProductId(int id) {
    emit(state.copyWith(productId: id));
    _printCurrentState("Product ID set to $id");
  }

  /// Initialize the cubit's state with existing product data for editing.
  void initWithProductData(Product product) {
    emit(state.copyWith(
      productId: product.id,
      productName: product.productName,
      productTitle: product.title,
      description: product.description,
      price: product.originalPrice,
      quantity: product.quantity,
      categoryId: 1, // Default category ID - adjust as needed
      images: [product.productImage], // Assuming one image for now
      selectedColors: [], // Initialize empty colors list
      selectedColorNames: [], // Initialize empty color names list
    ));
    print('Product data initialized for editing: ${product.productName}');
  }

  /// Update an existing product with comprehensive validation and error handling
  Future<bool> updateProduct() async {
    // Validate required fields
    if (!_validateProductData()) {
      return false;
    }

    // Store the old product ID for deletion
    final oldProductId = state.productId.toString();

    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Create product model from current state
      final product = ProductModel(
        id: state.productId.toString(),
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

      // Log product data for debugging
      _logProductData('UPDATING', product);

      // Send update request to API
      final response = await _sendUpdateRequest(product);

      if (response.success) {
        // After successful update, delete the old product
        print(
            'Product updated successfully. Now deleting old product: $oldProductId');

        final deleteResponse = await deleteProductById(oldProductId);

        if (deleteResponse.success) {
          print('Old product deleted successfully: $oldProductId');
          emit(state.copyWith(isLoading: false, error: null));
          return true;
        } else {
          print(
              'Warning: Product updated but failed to delete old version: ${deleteResponse.message}');
          // Still return true since the update was successful
          emit(state.copyWith(isLoading: false, error: null));
          return true;
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _handleUpdateError(e);
      return false;
    }
  }

  /// Validate product data before update
  bool _validateProductData() {
    if (state.productId == null || state.productId == 0) {
      emit(state.copyWith(error: 'Product ID is missing. Cannot update.'));
      print('Validation Error: Product ID is missing');
      return false;
    }

    if (state.productName.isEmpty) {
      emit(state.copyWith(error: 'Product name cannot be empty.'));
      print('Validation Error: Product name is empty');
      return false;
    }

    if (state.productTitle.isEmpty || state.productTitle.length < 10) {
      emit(state.copyWith(
          error: 'Product title must be at least 10 characters.'));
      print(
          'Validation Error: Product title is too short (${state.productTitle.length} chars)');
      return false;
    }

    if (state.description.isEmpty || state.description.length < 20) {
      emit(state.copyWith(
          error: 'Product description must be at least 20 characters.'));
      print(
          'Validation Error: Product description is too short (${state.description.length} chars)');
      return false;
    }

    if (state.price <= 0) {
      emit(state.copyWith(error: 'Product price must be greater than 0.'));
      print('Validation Error: Invalid price (${state.price})');
      return false;
    }

    if (state.quantity <= 0) {
      emit(state.copyWith(error: 'Product quantity must be greater than 0.'));
      print('Validation Error: Invalid quantity (${state.quantity})');
      return false;
    }

    if (state.categoryId <= 0) {
      emit(state.copyWith(error: 'Please select a valid category.'));
      print('Validation Error: Invalid category ID (${state.categoryId})');
      return false;
    }

    if (state.images.isEmpty) {
      emit(state.copyWith(error: 'Please add at least one product image.'));
      print('Validation Error: No images provided');
      return false;
    }

    return true;
  }

  /// Send update request to API
  Future<ApiResponse> _sendUpdateRequest(ProductModel product) async {
    try {
      // Prepare product data for API
      final productData = {
        'id': product.id,
        'name': product.name,
        'shortDescription': product.title,
        'longDescription': product.description,
        'price': product.price.toString(),
        'quantity': product.quantity.toString(),
        'categoryId': product.categoryId.toString(),
        'active': product.isActive.toString(),
        'colors': "[${product.colors.join(',')}]",
      };

      // Prepare files for multipart request
      Map<String, File>? files;
      if (product.images.isNotEmpty) {
        files = {'file': File(product.images[0])};
      }

      // Send update request
      final response = await postFormData(
        '/products',
        body: productData,
        files: files,
        isUpdate: true,
      );

      // Log response for debugging
      print('Update API Response Status: ${response.statusCode}');
      print('Update API Response Data: ${response.data}');

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data
            : {'productId': product.id};

        return ApiResponse(
          success: true,
          message: 'Product updated successfully',
          data: responseData,
        );
      } else {
        final errorMessage = response.data is Map<String, dynamic>
            ? response.data['message'] ?? 'Failed to update product'
            : 'Failed to update product: ${response.statusCode}';

        return ApiResponse(
          success: false,
          message: errorMessage,
        );
      }
    } catch (e) {
      print('Error in _sendUpdateRequest: ${e.toString()}');
      if (e is DioException) {
        _logDioError(e);
      }

      return ApiResponse(
        success: false,
        message: 'Error updating product: ${e.toString()}',
      );
    }
  }

  /// Handle update errors
  void _handleUpdateError(dynamic error) {
    print('Error in updateProduct: ${error.toString()}');

    String errorMessage = error.toString();

    if (error is DioException) {
      _logDioError(error);

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (error.type == DioExceptionType.unknown) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (error.response?.statusCode == 401) {
        errorMessage = 'Authentication failed. Please check your login status.';
      } else if (error.response?.statusCode == 404) {
        errorMessage = 'Product not found. Please check the product ID.';
      } else if (error.response?.statusCode == 500) {
        errorMessage = 'Server error occurred. Please try again later.';
      }
    }

    emit(state.copyWith(isLoading: false, error: errorMessage));
  }

  /// Log Dio error details
  void _logDioError(DioException error) {
    print('Dio Error Details:');
    print('  Type: ${error.type}');
    print('  Message: ${error.message}');
    print('  Status Code: ${error.response?.statusCode}');
    print('  Response Data: ${error.response?.data}');
  }

  /// Log product data for debugging
  void _logProductData(String action, ProductModel product) {
    print('======= $action PRODUCT DATA =======');
    print('Product ID: ${product.id}');
    print('Product Name: ${product.name}');
    print('Product Title: ${product.title}');
    print('Description: ${product.description}');
    print('Price: ${product.price}');
    print('Quantity: ${product.quantity}');
    print('Category ID: ${product.categoryId}');
    print('Colors: ${product.colors}');
    print('Images: ${product.images}');
    print('====================================');
  }

  // Method to send product data to API
  Future<ApiResponse> sendProductToApi(ProductModel product) async {
    try {
      // ignore: unused_local_variable
      const String apiUrl =
          'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/products';

      // Convert all product fields to strings
      final productData = {
        'name': product.name,

        'shortDescription': product.title,
        'longDescription': product.description, //must be longer than 20 chars
        'price': product.price.toString(),
        'quantity': product.quantity.toString(),
        'categoryId': product.categoryId.toString(),
        'active': product.isActive.toString(),
        'colors': "[${product.colors.join(',').toString()}]",
      };

      // Create FormData for multipart request
      final formData = FormData.fromMap(productData);
      formData.files.add(MapEntry(
          "file", await MultipartFile.fromFileSync(product.images[0])));
      // Make the API call using Dio
      final response = await postFormData(
        '/products',
        body: productData,
        files: {'file': File(product.images[0])},
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

  /// Check if we're in edit mode
  bool get isEditMode => state.productId != null;

  /// Get appropriate button text based on mode
  String get submitButtonText =>
      isEditMode ? 'UPDATE PRODUCT' : 'CREATE PRODUCT';
}

Future postFormData(String path,
    {Map<String, dynamic>? body,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isUpdate = false}) async {
  try {
    final authDataSource = AuthSharedPrefLocalDataSource();
    final token = await authDataSource.getToken();

    if (token == null) {
      throw UnauthorizedException();
    }

    final dio = Dio(BaseOptions(
        baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => true,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        }));

    dio.interceptors.add(AppIntercepters());
    FormData formData = FormData.fromMap(body ?? {});

    // For update operations, add a _method field to indicate PUT
    if (isUpdate) {
      formData.fields.add(MapEntry("_method", "put"));
    }

    if (files != null && files.isNotEmpty) {
      for (var file in files.entries) {
        formData.files.add(
            MapEntry(file.key, await MultipartFile.fromFile(file.value.path)));
      }
    }
    log("formData: ${formData.fields}");

    // Determine if we should use PUT or POST based on whether this is an update
    final method = isUpdate ? 'PUT' : 'POST';
    log("Using HTTP method: $method for path: $path");

    // Use the appropriate HTTP method
    final response = await dio.post(path,
        data: formData,
        options: Options(
          method: method,
          headers: {
            AppStrings.contentType: AppStrings.multipartFile,
            ...headers ?? {}
          },
        ),
        queryParameters: queryParameters);

    return response;
  } on DioException catch (error) {
    _handleDioError(error);
  }
}

dynamic _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw const FetchDataException();

    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case StatusCode.badRequest:
          throw const BadRequestException();
        case StatusCode.forbidden:
          throw const UnauthorizedException();
        case StatusCode.notFound:
          throw const NotFoundException();
        case StatusCode.conflict:
          throw const ConflictException();
        case StatusCode.internalServerError:
          throw const InternalServerErrorException();
      }
      break;
    case DioExceptionType.cancel:
      break;
    case DioExceptionType.unknown:
      throw const NoInternetConnectionException();
    default:
      throw Exception('Unhandled Dio Error: ${error.type}');
  }
}

// Method to delete a product by ID
Future<ApiResponse> deleteProductById(String productId) async {
  try {
    print('Deleting product with ID: $productId');
    final authDataSource = AuthSharedPrefLocalDataSource();
    final token = await authDataSource.getToken();

    if (token == null) {
      throw UnauthorizedException();
    }

    final response = await Dio(BaseOptions(
        baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
        headers: {
          "Authorization": "Bearer $token",
        })).delete('/products/$productId');

    print('Delete response status: ${response.statusCode}');
    print('Delete response data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return ApiResponse(
        success: true,
        message: 'Product deleted successfully',
      );
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to delete product: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('Error deleting product: $e');
    return ApiResponse(
      success: false,
      message: 'Error deleting product: $e',
    );
  }
}
