import 'package:flutter_test/flutter_test.dart';
import 'package:Herfa/features/add_new_product/viewmodels/cubit/new_post_viewmodel.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:flutter/material.dart';

void main() {
  group('Product Update Tests', () {
    late NewPostCubit cubit;

    setUp(() {
      cubit = NewPostCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('should initialize with product data for editing', () {
      // Arrange
      final product = Product(
        id: 1,
        productName: 'Test Product',
        title: 'Test Product Title',
        description:
            'This is a test product description that is longer than 20 characters',
        originalPrice: 99.99,
        discountedPrice: 89.99,
        quantity: 10,
        productImage: 'test_image.jpg',
        userFirstName: 'Test',
        userUsername: 'testuser',
        userImage: 'user_image.jpg',
         userLastName:'testuser' ,
      );

      // Act
      cubit.initWithProductData(product);

      // Assert
      expect(cubit.state.productName, equals('Test Product'));
      expect(cubit.state.productTitle, equals('Test Product Title'));
      expect(
          cubit.state.description,
          equals(
              'This is a test product description that is longer than 20 characters'));
      expect(cubit.state.price, equals(99.99));
      expect(cubit.state.quantity, equals(10));
      expect(cubit.state.productId, equals(1));
    });

    test('should validate product data correctly', () {
      // Arrange - Set up valid product data
      cubit.updateProductName('Valid Product Name');
      cubit.updateProductTitle('Valid Product Title');
      cubit.updateDescription(
          'This is a valid description that is longer than 20 characters');
      cubit.updatePrice(50.0);
      cubit.updateQuantity(5);
      cubit.updateCategoryId(1);
      cubit.toggleColor(Colors.red, 'Red');
      cubit.addImage('test_image.jpg');

      // Act & Assert - This should not throw any validation errors
      expect(cubit.state.productName.isNotEmpty, isTrue);
      expect(cubit.state.productTitle.length >= 10, isTrue);
      expect(cubit.state.description.length >= 20, isTrue);
      expect(cubit.state.price > 0, isTrue);
      expect(cubit.state.quantity > 0, isTrue);
      expect(cubit.state.categoryId > 0, isTrue);
      expect(cubit.state.selectedColors.isNotEmpty, isTrue);
      expect(cubit.state.images.isNotEmpty, isTrue);
    });

    test('should detect edit mode correctly', () {
      // Arrange & Act
      expect(cubit.isEditMode, isFalse);

      cubit.setProductId(123);

      // Assert
      expect(cubit.isEditMode, isTrue);
    });

    test('should provide correct submit button text', () {
      // Test create mode
      expect(cubit.submitButtonText, equals('CREATE PRODUCT'));

      // Test edit mode
      cubit.setProductId(123);
      expect(cubit.submitButtonText, equals('UPDATE PRODUCT'));
    });

    test('should handle delete-and-recreate update process', () {
      // Arrange - Set up for edit mode
      cubit.setProductId(123);
      cubit.updateProductName('Updated Product');
      cubit.updateProductTitle('Updated Title');
      cubit.updateDescription(
          'Updated description that is longer than 20 characters');
      cubit.updatePrice(150.0);
      cubit.updateQuantity(15);
      cubit.updateCategoryId(2);
      cubit.toggleColor(Colors.blue, 'Blue');
      cubit.addImage('updated_image.jpg');

      // Assert - Verify the state is set up for update
      expect(cubit.isEditMode, isTrue);
      expect(cubit.state.productId, equals(123));
      expect(cubit.state.productName, equals('Updated Product'));
      expect(cubit.state.productTitle, equals('Updated Title'));
      expect(cubit.state.description,
          equals('Updated description that is longer than 20 characters'));
      expect(cubit.state.price, equals(150.0));
      expect(cubit.state.quantity, equals(15));
      expect(cubit.state.categoryId, equals(2));
      expect(cubit.state.selectedColors.contains(Colors.blue), isTrue);
      expect(cubit.state.images.contains('updated_image.jpg'), isTrue);
    });

    test('should update state correctly when modifying product fields', () {
      // Test product name update
      cubit.updateProductName('New Product Name');
      expect(cubit.state.productName, equals('New Product Name'));

      // Test price update
      cubit.updatePrice(199.99);
      expect(cubit.state.price, equals(199.99));

      // Test quantity update
      cubit.updateQuantity(25);
      expect(cubit.state.quantity, equals(25));

      // Test category update
      cubit.updateCategoryId(3);
      expect(cubit.state.categoryId, equals(3));
    });

    test('should handle color selection correctly', () {
      // Initially no colors selected
      expect(cubit.state.selectedColors.isEmpty, isTrue);
      expect(cubit.state.selectedColorNames?.isEmpty ?? true, isTrue);

      // Add a color
      cubit.toggleColor(Colors.blue, 'Blue');
      expect(cubit.state.selectedColors.contains(Colors.blue), isTrue);
      expect(cubit.state.selectedColorNames?.contains('Blue') ?? false, isTrue);

      // Remove the color
      cubit.toggleColor(Colors.blue, 'Blue');
      expect(cubit.state.selectedColors.contains(Colors.blue), isFalse);
      expect(
          cubit.state.selectedColorNames?.contains('Blue') ?? false, isFalse);
    });

    test('should handle image management correctly', () {
      // Initially no images
      expect(cubit.state.images.isEmpty, isTrue);

      // Add an image
      cubit.addImage('image1.jpg');
      expect(cubit.state.images.length, equals(1));
      expect(cubit.state.images.contains('image1.jpg'), isTrue);

      // Add another image
      cubit.addImage('image2.jpg');
      expect(cubit.state.images.length, equals(2));

      // Delete an image
      cubit.deleteImage('image1.jpg');
      expect(cubit.state.images.length, equals(1));
      expect(cubit.state.images.contains('image1.jpg'), isFalse);
      expect(cubit.state.images.contains('image2.jpg'), isTrue);
    });
  });
}
