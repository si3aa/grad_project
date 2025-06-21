import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../user/viewmodel/user_viewmodel.dart';
import '../ss.dart';

class UserDataTestScreen extends StatefulWidget {
  const UserDataTestScreen({Key? key}) : super(key: key);

  @override
  State<UserDataTestScreen> createState() => _UserDataTestScreenState();
}

class _UserDataTestScreenState extends State<UserDataTestScreen> {
  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<UserViewModel>(
              builder: (context, userViewModel, child) {
                if (userViewModel.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (userViewModel.error != null) {
                  return Text('Error: ${userViewModel.error}');
                }

                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        testUserData(context);
                      },
                      child: const Text('Test User Data'),
                    ),
                    const SizedBox(height: 20),
                    const UserDataPrinter(),
                    if (userViewModel.currentUser != null)
                      Text('Current user: ${userViewModel.currentUser!.username}'),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Manually refresh user data
                context.read<UserViewModel>().getCurrentUser();
              },
              child: const Text('Refresh User Data'),
            ),
          ],
        ),
      ),
    );
  }
}
