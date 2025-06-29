import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';
import 'package:Herfa/features/get_user_img/index.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final userRole = userViewModel.userRole;
        final isUserRole = userRole == 'USER';
        final userId = userViewModel.userId;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // User Profile Image - Simple and Clean
                  if (userId != null)
                    CachedUserImageWidget(
                      userId: userId,
                      radius: 20,
                    )
                  else
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome 👋",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        userViewModel.fullName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: isUserRole ? null : Colors.grey,
                    ),
                    onPressed: isUserRole
                        ? () {
                            Navigator.pushNamed(context, '/change-role');
                          }
                        : null,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "We have prepared new products for you",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
