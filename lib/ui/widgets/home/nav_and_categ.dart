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
    final userRole = Provider.of<UserViewModel>(context, listen: false).userRole;
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
            onTap: userRole == 'USER' ? () {} : () => onTap(3), // Disable for USER by using empty function
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
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int selectedIndex = 0;
  final List<Map<String, String>> categories = [
    {"title": "All", "route": "/All"},
    {"title": "Accessories", "route": "/jewelry"},
    {"title": "handmade", "route": "/clothing"},
    {"title": "Art", "route": "/home_decor"},
  ];

  @override
  Widget build(BuildContext context) {
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
            route: category["route"]!,
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // Optionally, navigate or do something with category["route"]
            },
          );
        },
      ),
    );
  }
}
