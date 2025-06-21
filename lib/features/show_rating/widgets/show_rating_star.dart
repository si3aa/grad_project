import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/show_rating_viewmodel.dart';

class ShowRatingStar extends StatelessWidget {
  final int productId;
  final double iconSize;
  final Color iconColor;
  final Color? textColor;
  const ShowRatingStar({
    Key? key,
    required this.productId,
    this.iconSize =25,
    this.iconColor = Colors.amber,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowRatingViewModel>(
      create: (_) => ShowRatingViewModel()..fetchRating(productId),
      child: Consumer<ShowRatingViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return SizedBox(
              width: iconSize * 2,
              height: iconSize,
              child: Center(
                child: SizedBox(
                  width: iconSize * 0.6,
                  height: iconSize * 0.6,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          if (vm.error != null) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_border, color: Colors.grey, size: iconSize),
                const SizedBox(width: 2),
                Text(
                  '0.0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor ?? Colors.black,
                    fontSize: iconSize * 0.9,
                  ),
                ),
              ],
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: iconColor, size: iconSize),
              const SizedBox(width: 2),
              Text(
                vm.rating?.toStringAsFixed(1) ?? '0.0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black,
                  fontSize: iconSize * 0.9,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
