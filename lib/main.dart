import 'package:Herfa/ui/provider/controller.dart';
import 'package:Herfa/ui/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ForgetPasswordController()),
        ChangeNotifierProvider(create: (context) => VerifyCodeController()),
      ],
      child: const Herfa(),
    ),
  );
}

class Herfa extends StatelessWidget {
  const Herfa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: NavigationController.routes,
    );
  }
}
