import 'package:flutter/material.dart';

class NewPostState {
  final String productName;
  final String productTitle;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final List<Color> selectedColors;
  final List<String>? selectedColorNames;
  final List<String> images;
  final bool isLoading;
  final String? error;
  final int? productId;

  NewPostState({
    this.productName = '',
    this.productTitle = '',
    this.description = '',
    this.price = 0.0,
    this.quantity = 0,
    this.categoryId = 0,
    this.selectedColors = const [],
    this.selectedColorNames = const [],
    this.images = const [],
    this.isLoading = false,
    this.error,
    this.productId,
  });

  NewPostState copyWith({
    String? productName,
    String? productTitle,
    String? description,
    double? price,
    int? quantity,
    int? categoryId,
    List<Color>? selectedColors,
    List<String>? selectedColorNames,
    List<String>? images,
    bool? isLoading,
    String? error,
    int? productId,
  }) {
    return NewPostState(
      productName: productName ?? this.productName,
      productTitle: productTitle ?? this.productTitle,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categoryId: categoryId ?? this.categoryId,
      selectedColors: selectedColors ?? this.selectedColors,
      selectedColorNames: selectedColorNames ?? this.selectedColorNames,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      productId: productId ?? this.productId,
    );
  }
}