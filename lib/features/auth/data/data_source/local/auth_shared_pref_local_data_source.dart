import 'package:Herfa/core/constant.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
