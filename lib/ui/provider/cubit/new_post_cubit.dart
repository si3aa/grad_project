import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit() : super(NewPostState());

  void updateProductName(String name) {
    emit(state.copyWith(productName: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void addImage(String imagePath) {
    if (imagePath.isEmpty) return;
    emit(state.copyWith(images: List.from(state.images)..add(imagePath)));
  }

  void deleteImage(String imagePath) {
    final updatedImages = List<String>.from(state.images);
    updatedImages.remove(imagePath);
    
    emit(state.copyWith(images: updatedImages));
  }

  void updateSpecifications({
    String? material,
    String? size,
    double? price,
    String? color,
  }) {
    emit(state.copyWith(
      material: material,
      size: size,
      price: price,
      color: color,
    ));
  }

  void updateAdditionalInfo({
    String? shippingDetails,
    double? shippingPrice,
    String? returnPolicy,
    String? paymentMethods,
  }) {
    emit(state.copyWith(
      shippingDetails: shippingDetails,
      shippingPrice: shippingPrice,
      returnPolicy: returnPolicy,
      paymentMethods: paymentMethods,
    ));
  }

  void initializeDefaults() {}
}

class NewPostState {
  final String productName;
  final String description;
  final List<String> images;
  final String material;
  final String size;
  final double price;
  final String color;
  final String shippingDetails;
  final double shippingPrice;
  final String returnPolicy;
  final String paymentMethods;

  NewPostState({
    this.productName = '',
    this.description = '',
    this.images = const [],
    this.material = '',
    this.size = '',
    this.price = 0.0,
    this.color = '',
    this.shippingDetails = '',
    this.shippingPrice = 0.0,
    this.returnPolicy = '',
    this.paymentMethods = '',
  });

  NewPostState copyWith({
    String? productName,
    String? description,
    List<String>? images,
    String? material,
    String? size,
    double? price,
    String? color,
    String? shippingDetails,
    double? shippingPrice,
    String? returnPolicy,
    String? paymentMethods,
  }) {
    return NewPostState(
      productName: productName ?? this.productName,
      description: description ?? this.description,
      images: images ?? this.images,
      material: material ?? this.material,
      size: size ?? this.size,
      price: price ?? this.price,
      color: color ?? this.color,
      shippingDetails: shippingDetails ?? this.shippingDetails,
      shippingPrice: shippingPrice ?? this.shippingPrice,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
