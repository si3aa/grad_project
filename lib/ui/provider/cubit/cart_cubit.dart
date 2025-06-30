import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void fetchCart() {
    emit(CartLoaded(itemCount: 0, items: []));
  }

  void addItem(CartItem item) {
    final currentState = state is CartLoaded
        ? state as CartLoaded
        : CartLoaded(itemCount: 0, items: []);
    final existingIndex = currentState.items
        .indexWhere((e) => e.id == item.id && e.couponCode == item.couponCode);
    List<CartItem> updatedItems = List<CartItem>.from(currentState.items);
    if (existingIndex != -1) {
      // If item exists, update quantity (prevent duplicate)
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] =
          existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      updatedItems.add(item);
    }
    emit(CartLoaded(itemCount: updatedItems.length, items: updatedItems));
  }

  void updateQuantity(int productId, int quantity, {String? couponCode}) {
    final currentState = state as CartLoaded;
    final updatedItems = currentState.items.map((item) {
      if (item.id == productId && item.couponCode == couponCode) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    emit(CartLoaded(itemCount: updatedItems.length, items: updatedItems));
  }

  void removeItem(int productId, {String? couponCode}) {
    final currentState = state as CartLoaded;
    final updatedItems = currentState.items
        .where((item) => item.id != productId || item.couponCode != couponCode)
        .toList();
    emit(CartLoaded(itemCount: updatedItems.length, items: updatedItems));
  }

  void clearCart() {
    emit(CartLoaded(itemCount: 0, items: []));
  }
}

class CartState {
  final int itemCount;
  final List<CartItem> items;

  CartState({this.itemCount = 0, this.items = const []});
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  CartLoaded({required int itemCount, required List<CartItem> items})
      : super(itemCount: itemCount, items: items);
}

class CartItem {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final String? couponCode;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.couponCode,
  });

  CartItem copyWith({
    int? quantity,
    String? couponCode,
  }) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      couponCode: couponCode ?? this.couponCode,
    );
  }
}
