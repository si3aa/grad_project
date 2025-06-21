import 'package:flutter/material.dart';
import '../widgets/show_rating_star.dart';

class ShowRatingStarView extends StatelessWidget {
  final int productId;
  const ShowRatingStarView({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowRatingStar(productId: productId);
  }
}
