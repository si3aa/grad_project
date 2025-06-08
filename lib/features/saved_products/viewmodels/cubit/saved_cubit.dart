import 'package:flutter_bloc/flutter_bloc.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(SavedInitial());

  void fetchSavedItems() {
    final savedItems = [
      SavedItem(
        id: 1,
        name: "Exfoliating Face Scrub",
        originalPrice: 39.00,
        discountedPrice: 12.00,
        discountPercentage: 60,
        rating: 4.8,
        reviewCount: 512,
        imageUrl: "assets/images/product_1.png",
      ),
      SavedItem(
        id: 2,
        name: "Nude Matte Nail Polish",
        originalPrice: 28.00,
        discountedPrice: 16.00,
        discountPercentage: 40,
        rating: 4.0,
        reviewCount: 1782,
        imageUrl: "assets/images/product_2.png",
      ),
      SavedItem(
        id: 3,
        name: "Nourishing Lip Balm",
        originalPrice: 68.00,
        discountedPrice: 32.00,
        discountPercentage: 55,
        rating: 3.5,
        reviewCount: 23,
        imageUrl: "assets/images/product_3.png",
      ),
      SavedItem(
        id: 4,
        name: "Long-Wear Gel Eyeliner",
        originalPrice: 14.00,
        discountedPrice: 8.00,
        discountPercentage: 40,
        rating: 4.5,
        reviewCount: 2346,
        imageUrl: "assets/images/product_1.png",
      ),
    ];
    emit(SavedLoaded(savedItems: savedItems));
  }

  void clearSavedItems() {
    emit(SavedLoaded(savedItems: []));
  }
}

class SavedState {
  final List<SavedItem>? savedItems;

  SavedState({this.savedItems});
}

class SavedInitial extends SavedState {}

class SavedLoaded extends SavedState {
  SavedLoaded({required this.savedItems}) : super(savedItems: savedItems);

  final List<SavedItem> savedItems;
}

class SavedItem {
  final int id;
  final String name;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  SavedItem({
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}