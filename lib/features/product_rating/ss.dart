import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/user/viewmodel/user_viewmodel.dart';

class UserDataPrinter extends StatelessWidget {
  const UserDataPrinter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    developer.log('UserDataPrinter widget is building', name: 'Debug');
    
    try {
      // Try to get the UserViewModel
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      developer.log('UserViewModel accessed successfully', name: 'Debug');

      // Check if ViewModel exists
      developer.log('UserViewModel is not null', name: 'Debug');
      
      // Check if currentUser exists
      final user = userViewModel.currentUser;
      if (user != null) {
        developer.log('Found user data:', name: 'Debug');
        developer.log('ID: ${user.id}', name: 'Debug');
        developer.log('Username: ${user.username}', name: 'Debug');
        developer.log('Role: ${user.role}', name: 'Debug');
      } else {
        developer.log('currentUser is null in UserViewModel', name: 'Debug');
      }
        } catch (e, stackTrace) {
      developer.log('Error accessing UserViewModel: $e', name: 'Debug');
      developer.log('Stack trace: $stackTrace', name: 'Debug');
    }

    // Return an empty container since we only need to print data
    return const SizedBox.shrink();
  }
}

// Function to use outside of widget tree
void printCurrentUserData(BuildContext context) {
  final userViewModel = Provider.of<UserViewModel>(context, listen: false);
  final user = userViewModel.currentUser;
  if (user != null) {
    developer.log('================ Current User Details ================', name: 'UserData');
    developer.log('ID: ${user.id}', name: 'UserData');
    developer.log('Username: ${user.username}', name: 'UserData');
    developer.log('Full Name: ${user.fullName}', name: 'UserData');
    developer.log('Role: ${user.role}', name: 'UserData');
    developer.log('Verified: ${user.verified}', name: 'UserData');
    
    if (user.profile != null) {
      developer.log('Profile Information:', name: 'UserData');
      developer.log('  Name: ${user.profile!.firstName} ${user.profile!.lastName}', name: 'UserData');
      developer.log('  Phone: ${user.profile!.phone}', name: 'UserData');
      developer.log('  Address: ${user.profile!.address}', name: 'UserData');
      developer.log('  Bio: ${user.profile!.bio}', name: 'UserData');
      if (user.profile!.profilePictureUrl != null) {
        developer.log('  Profile Picture: ${user.profile!.profilePictureUrl}', name: 'UserData');
      }
    }
    developer.log('================================================', name: 'UserData');
  } else {
    developer.log('No user data available', name: 'UserData');
  }
}

// Add a simpler test function
void testUserData(BuildContext context) {
  developer.log('====== Testing User Data Access ======', name: 'UserTest');
  
  try {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    developer.log('Successfully accessed UserViewModel', name: 'UserTest');

    final user = userViewModel.currentUser;
    if (user != null) {
      developer.log('Found user data:', name: 'UserTest');
      developer.log('''
================ Current User Details ================
ID: ${user.id}
Username: ${user.username}
Full Name: ${user.fullName}
Role: ${user.role}
Verified: ${user.verified}
${user.profile != null ? '''
Profile Information:
  Name: ${user.profile!.firstName} ${user.profile!.lastName}
  Phone: ${user.profile!.phone}
  Address: ${user.profile!.address}
  Bio: ${user.profile!.bio}
  ${user.profile!.profilePictureUrl != null ? 'Profile Picture: ${user.profile!.profilePictureUrl}' : 'No profile picture'}''' : 'No profile data'}
================================================
''', name: 'UserTest');
    } else {
      developer.log('No user data available - currentUser is null', name: 'UserTest');
      // Try to refresh user data
      userViewModel.getCurrentUser().then((_) {
        developer.log('Attempted to refresh user data', name: 'UserTest');
      }).catchError((error) {
        developer.log('Error refreshing user data: $error', name: 'UserTest');
      });
    }
  } catch (e, stackTrace) {
    developer.log('Error accessing user data: $e', name: 'UserTest');
    developer.log('Stack trace: $stackTrace', name: 'UserTest');
  }
  
  developer.log('====== User Data Test Complete ======', name: 'UserTest');
}