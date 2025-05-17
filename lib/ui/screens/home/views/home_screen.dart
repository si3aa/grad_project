import 'package:Herfa/features/add_new_product/views/screens/new_post_screen.dart';
import 'package:Herfa/ui/screens/home/views/cart_screen.dart';
import 'package:Herfa/ui/screens/home/views/events_screen.dart';
import 'package:Herfa/ui/screens/home/views/posts_tab.dart';
import 'package:Herfa/ui/screens/home/views/saved_screen.dart';
import 'package:Herfa/ui/widgets/home/nav_and_categ.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  final List<Widget> tabs = [
    const PostsTab(),
    const EventsScreen(),
    const SavedScreen(),
    const NewPostScreen(),
    const CartScreen()
  ];
  
  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavBarWidget(
        currentIndex: currentTabIndex,
        onTap: onTabTapped,
      ),
    );
  }
}

 
