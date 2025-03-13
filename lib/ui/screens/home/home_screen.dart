import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/widgets/home/build_cate_button.dart';
import 'package:Herfa/ui/widgets/home/build_nav_icon.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onNavIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset("assets/images/arrow-small-left.png"),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome 👋",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            "Rahma Moammed",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                      ),
                    ],
                  ),
                ),
                // Message
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "We have prepared new products for you",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for anything on Herfa",
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Category Buttons
                SizedBox(
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
                ),
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
                        icon: Icons.card_giftcard,
                        label: "Gifts",
                        route: "/gifts",
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
                        route: "/add",
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
            ),
          ),
        ],
      ),
    );
  }
}
