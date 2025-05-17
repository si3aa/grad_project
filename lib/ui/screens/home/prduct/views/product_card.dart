
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/ui/screens/home/prduct/views/product_action.dart';
import 'package:Herfa/ui/screens/home/prduct/views/product_class.dart';
import 'package:Herfa/ui/screens/home/prduct/views/product_detail.dart';
import 'package:Herfa/ui/screens/home/prduct/views/product_image.dart';
import 'package:Herfa/ui/screens/home/prduct/views/user_info.dart';
import 'package:flutter/material.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onCart;
  final VoidCallback onMore;

  const ProductCard({
    super.key,
    required this.product,
    required this.onLike,
    required this.onComment,
    required this.onCart,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetailRoute,
          arguments: {'product': product},
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                userName: product.userName,
                userHandle: product.userHandle,
                userImage: product.userImage,
                onMore: onMore,
              ),
              const SizedBox(height: 10),
              ProductImage(
                productImage: product.productImage,
              ),
              const SizedBox(height: 10),
              ProductDetails(
                productName: product.productName,
                originalPrice: product.originalPrice,
                description: product.title,
                onCart: onCart,
              ),
              const SizedBox(height: 10),
              ProductInteractions(
                likes: product.likes,
                comments: product.comments,
                onLike: onLike,
                onComment: onComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}









