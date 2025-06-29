import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/views/widgets/product_detail.dart';
import 'package:Herfa/features/get_product/views/widgets/product_image.dart';
import 'package:Herfa/features/favorites/views/widgets/favorite_button.dart';
import 'package:Herfa/features/show_rating/widgets/show_rating_star.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';
import 'package:Herfa/features/follow/widgets/follow_button.dart';
import 'package:Herfa/features/get_user_img/index.dart';

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
  // bool isFollowing = false; // Remove this, now handled by cubit

  // Helper method to capitalize first letter
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Helper method to build full name with debugging
  String buildFullName(String firstName, String lastName) {
    print('Debug - First Name: "$firstName"');
    print('Debug - Last Name: "$lastName"');

    // Handle null or empty values
    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();

    if (cleanFirstName.isEmpty && cleanLastName.isEmpty) {
      return 'Unknown User';
    }

    if (cleanFirstName.isEmpty) {
      return capitalizeFirstLetter(cleanLastName);
    }

    if (cleanLastName.isEmpty) {
      return cleanFirstName;
    }

    final fullName = '$cleanFirstName ${capitalizeFirstLetter(cleanLastName)}';
    print('Debug - Full Name: "$fullName"');
    return fullName;
  }

  @override
  Widget build(BuildContext context) {
    final userRole =
        Provider.of<UserViewModel>(context, listen: false).userRole;
    final currentProduct = widget.product;
    // Build full name with debugging
    final fullName = buildFullName(
        currentProduct.userFirstName, currentProduct.userLastName);

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
            arguments: {'product': currentProduct},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom user info display to match product details screen
              Row(
                children: [
                  CachedUserImageWidget(
                    userId: currentProduct.userId,
                    radius: 20,
                    onTap: () {
                      // Navigate to user profile if needed
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName, // Combined first name + capitalized last name
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          currentProduct.userUsername, // Handle null username
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  // Move FollowButton here, before the more icon
                  FollowButton(userId: currentProduct.userUsername),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: userRole == 'USER'
                        ? null
                        : () => widget.onMore(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ProductImage(
                productImage: currentProduct.productImage,
              ),
              const SizedBox(height: 10),
              ProductDetails(
                productId: currentProduct.id.toString(),
                productName: currentProduct.productName,
                originalPrice: currentProduct.originalPrice,
                description: currentProduct.title,
                onCart: widget.onCart,
                isSaved: false,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FavoriteButton(
                    productId: currentProduct.id.toString(),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.commentsRoute,
                        arguments: {
                          'productId': currentProduct.id.toString(),
                          'userUsername': currentProduct.userUsername,
                        },
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Provider.of<UserViewModel>(context, listen: false)
                                  .userRole ==
                              'USER'
                          ? ShowRatingStar(
                              productId: currentProduct.id,
                              iconSize: 24,
                              iconColor: Colors.amber,
                              textColor: Colors.black,
                            )
                          : const SizedBox.shrink(),
                    ),
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
