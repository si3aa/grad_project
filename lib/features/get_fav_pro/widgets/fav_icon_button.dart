import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/fav_viewmodel.dart';

class FavIconButton extends StatelessWidget {
  final String productId;

  const FavIconButton({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favViewModel = Provider.of<FavViewModel>(context);
    final isFavorite = favViewModel.isFavorite(productId);
    final loading = favViewModel.loading;

    return IconButton(
      icon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
      onPressed: loading ? null : () => favViewModel.toggleFavorite(productId),
    );
  }
}
