import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void fetchCart() {
    emit(CartLoaded(itemCount: 0, items: []));
  }

  void addItem(CartItem item) {
    final currentState = state as CartLoaded;
    final updatedItems = List<CartItem>.from(currentState.items)..add(item);
    emit(CartLoaded(itemCount: updatedItems.length, items: updatedItems));
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

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}