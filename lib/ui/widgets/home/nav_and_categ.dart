import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/search_cubit.dart';
import 'package:Herfa/ui/widgets/home/build_cate_button.dart';
import 'package:Herfa/ui/widgets/home/build_nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  @override
  // ignore: override_on_non_overriding_member
  int _selectedIndex = 0;
  void _onNavIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Column(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Container(
                height: 60,
                // ignore: deprecated_member_use
                color: kPrimaryColor.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BuildNavIcon(
                      icon: Icons.home,
                      label: "Home",
                      route: "/home",
                      isSelected: _selectedIndex == 0,
                      onTap: () => _onNavIconTap(0),
                    ),
                    BuildNavIcon(
                      icon: Icons.event,
                      label: "Events",
                      route: "/events",
                      isSelected: _selectedIndex == 1,
                      onTap: () => _onNavIconTap(1),
                    ),
                    BuildNavIcon(
                      icon: Icons.bookmark_border,
                      label: "Saved",
                      route: "/saved",
                      isSelected: _selectedIndex == 2,
                      onTap: () => _onNavIconTap(2),
                    ),
                    BuildNavIcon(
                      icon: Icons.add,
                      label: "Add",
                      route: "/new-post",
                      isSelected: _selectedIndex == 3,
                      onTap: () => _onNavIconTap(3),
                    ),
                    BuildNavIcon(
                      icon: Icons.shopping_cart,
                      label: "Cart",
                      route: "/cart",
                      isSelected: _selectedIndex == 4,
                      onTap: () => _onNavIconTap(4),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          CategoryButton(title: "All", route: "/All"),
          CategoryButton(title: "Jewelry", route: "/jewelry"),
          CategoryButton(title: "Clothing", route: "/clothing"),
          CategoryButton(title: "Home Decor", route: "/home_decor"),
          CategoryButton(title: "Find", route: "/find"),
        ],
      ),
    );
  }
}
