// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Herfa/features/user/viewmodel/user_viewmodel.dart';
import 'package:Herfa/features/get_user_img/index.dart';
import 'package:Herfa/core/constants/colors.dart';

class EnhancedHomeAppBar extends StatelessWidget {
  const EnhancedHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final userRole = userViewModel.userRole;
        final isUserRole = userRole == 'USER';
        final userId = userViewModel.userId;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // User Profile Image with Border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: userId != null
                            ? CachedUserImageWidget(
                                userId: userId,
                                radius: 22,
                                onTap: () {
                                  _showProfileOptions(context, userViewModel);
                                },
                              )
                            : Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // User Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Welcome 👋",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (userViewModel.isVerified) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userViewModel.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@${userViewModel.username}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Settings Button
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUserRole
                            ? kPrimaryColor.withOpacity(0.1)
                            : Colors.grey.shade200,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: isUserRole ? kPrimaryColor : Colors.grey,
                          size: 20,
                        ),
                        onPressed: isUserRole
                            ? () {
                                Navigator.pushNamed(context, '/change-role');
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              // Welcome Message
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kPrimaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "We have prepared new products for you",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileOptions(BuildContext context, UserViewModel userViewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: kPrimaryColor),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile screen coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: kPrimaryColor),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: kPrimaryColor),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/change-role');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
