import 'package:Herfa/ui/widgets/home/build_cate_button.dart';
import 'package:Herfa/ui/widgets/home/build_nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';

class NavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final userRole =
        Provider.of<UserViewModel>(context, listen: false).userRole;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BuildNavIcon(
            icon: Icons.home,
            label: "Home",
            route: "/home",
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          BuildNavIcon(
            icon: Icons.event,
            label: "Events",
            route: "/events",
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          BuildNavIcon(
            icon: Icons.bookmark_border,
            label: "Saved",
            route: "/saved",
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          BuildNavIcon(
            icon: Icons.add,
            label: "Add",
            route: "/new-post",
            isSelected: currentIndex == 3,
            onTap: userRole == 'USER'
                ? () {}
                : () => onTap(3), // Disable for USER by using empty function
          ),
          BuildNavIcon(
            icon: Icons.shopping_cart,
            label: "Cart",
            route: "/cart",
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class CategoriesList extends StatefulWidget {
  final void Function(int? categoryId)? onCategorySelected;
  final int? selectedCategoryId;
  const CategoriesList(
      {super.key, this.onCategorySelected, this.selectedCategoryId});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final List<Map<String, dynamic>> categories = [
    {"title": "All", "categoryId": null},
    {"title": "Accessories", "categoryId": 1},
    {"title": "handmade", "categoryId": 2},
    {"title": "Art", "categoryId": 3},
  ];

  int _getSelectedIndex() {
    final idx = categories
        .indexWhere((cat) => cat["categoryId"] == widget.selectedCategoryId);
    return idx == -1 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryButton(
            title: category["title"]!,
            route: "", // route is not used
            isSelected: selectedIndex == index,
            onTap: () {
              if (widget.onCategorySelected != null) {
                widget.onCategorySelected!(category["categoryId"]);
              }
            },
          );
        },
      ),
    );
  }
}
