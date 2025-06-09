import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/views/widgets/product_detail.dart';
import 'package:Herfa/features/get_product/views/widgets/product_image.dart';
import 'package:Herfa/features/get_product/views/widgets/user_info.dart';
import 'package:Herfa/features/get_product/views/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onCart;
  final Function(BuildContext) onMore;

  const ProductCard({
    super.key,
    required this.product,
    required this.onCart,
    required this.onMore,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.productDetailRoute,
            arguments: {'product': widget.product},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                userName: widget.product.userName,
                userHandle: widget.product.userHandle,
                userImage: widget.product.userImage,
                onMore: () => widget.onMore(context),
              ),
              const SizedBox(height: 10),
              ProductImage(
                productImage: widget.product.productImage,
              ),
              const SizedBox(height: 10),
              ProductDetails(
                productId: widget.product.id.toString(),
                productName: widget.product.productName,
                originalPrice: widget.product.originalPrice,
                description: widget.product.title,
                onCart: widget.onCart,
                isSaved: false,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FavoriteButton(
                    productId: widget.product.id.toString(),
                    initialIsFavorite:
                        false, // All products start as unfavorited
                    onFavoriteChanged: (isFavorite) {
                      // FavoriteButton manages its own state, no need to track here
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
