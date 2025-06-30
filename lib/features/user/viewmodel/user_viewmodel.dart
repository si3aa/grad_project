// import 'dart:convert';
// import 'dart:developer' as developer;
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../model/user_model.dart';
// import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

// class UserViewModel extends ChangeNotifier {
//   UserModel? _currentUser;
//   bool _isLoading = false;
//   String? _error;

//   final AuthSharedPrefLocalDataSource _authDataSource = AuthSharedPrefLocalDataSource();
//   final String _baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app';

//   UserModel? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   Future<void> getCurrentUser() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final token = await _authDataSource.getToken();
//       if (token == null) {
//         throw Exception('No token found');
//       }

//       final response = await http.get(
//         Uri.parse('$_baseUrl/auth/me'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         _currentUser = UserModel.fromJson(responseData['data']);
        
//         // Log user details to console
//         developer.log(_currentUser.toString(), name: 'UserViewModel');
        
//       } else {
//         throw Exception('Failed to load user data: ${response.statusCode}');
//       }
//     } catch (e) {
//       _error = e.toString();
//       developer.log('Error getting user: $_error', name: 'UserViewModel', error: e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> clearUser() async {
//     _currentUser = null;
//     notifyListeners();
//   }

//   String get username => _currentUser?.username ?? '';
//   String get fullName => _currentUser?.fullName ?? '';
//   int? get userId => _currentUser?.id;
//   String get userRole => _currentUser?.role ?? '';
//   bool get isVerified => _currentUser?.verified ?? false;
// }
