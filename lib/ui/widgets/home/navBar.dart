import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
import 'package:Herfa/ui/screens/home/home_content.dart';
import 'package:Herfa/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      onGenerateRoute: (settings) => _generateRoute(settings),
    );
  }

  Route _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/jewelry':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.home),
        );
      case '/clothing':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.home),
        );
      case '/home_decor':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.home),
        );
      case '/find':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.home),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.home),
        );
      case '/gifts':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.gifts),
        );
      case '/saved':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.saved),
        );
      case '/add':
        return MaterialPageRoute(
          builder: (_) => const ContentScreen(initialFilter: ContentFilter.add),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (_) =>
              const ContentScreen(initialFilter: ContentFilter.cart),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
