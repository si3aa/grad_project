import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ProductRatingCubit extends Cubit<int> {
  final int productId;
  final String token;
  ProductRatingCubit({required this.productId, required this.token, int initialRating = 0}) : super(initialRating);

  bool _isLoading = false;

  Future<void> rate(int star) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      int starsToSend = star;
      if (state == star) {
        // If user clicks the same star, set to 0 (unrate)
        starsToSend = 0;
      }
      final url = Uri.parse('https://zygotic-marys-herfa-c2dd67a8.koyeb.app/ratings?productId=$productId&stars=$starsToSend');
      print('[RATING REQUEST] POST: $url');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[RATING RESPONSE] Status: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(starsToSend); // Color all stars up to the clicked one
      }
    } finally {
      _isLoading = false;
    }
  }
}

class ProductRatingBar extends StatelessWidget {
  final int productId;
  final int initialRating;
  final String token;
  const ProductRatingBar({Key? key, required this.productId, this.initialRating = 0, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductRatingCubit(productId: productId, token: token, initialRating: initialRating),
      child: BlocBuilder<ProductRatingCubit, int>(
        builder: (context, rating) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return IconButton(
                icon: Icon(
                  rating >= starIndex ? Icons.star : Icons.star_border,
                  color: rating >= starIndex ? Colors.amber : Colors.grey,
                  size: 36,
                ),
                onPressed: () => context.read<ProductRatingCubit>().rate(starIndex),
              );
            }),
          );
        },
      ),
    );
  }
}
