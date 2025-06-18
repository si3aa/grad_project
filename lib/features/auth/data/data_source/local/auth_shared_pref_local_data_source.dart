import 'package:Herfa/core/constant.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthSharedPrefLocalDataSource extends AuthLocalDataSource {
  @override
  Future<void> saveToken(String token) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(CacheConstant.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(CacheConstant.tokenKey);
  }

  Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      // Split the token into parts
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      // Get the user ID from the payload
      return payloadMap['USERNAME']?.toString();
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
<<<<<<< HEAD
=======
  }

  // New method to save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(
        CacheConstant.userDataKey, json.encode(userData));
  }

  // New method to get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final sharedPref = await SharedPreferences.getInstance();
    final userDataString = sharedPref.getString(CacheConstant.userDataKey);
    if (userDataString == null) return null;
    return json.decode(userDataString) as Map<String, dynamic>;
>>>>>>> d4c41aced3d31467b8d9e75869fe8df36db0f5f9
  }
}
