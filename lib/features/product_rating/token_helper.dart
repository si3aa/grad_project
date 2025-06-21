import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';

class TokenHelper {
  static Future<String?> getToken() async {
    final authDataSource = AuthSharedPrefLocalDataSource();
    return await authDataSource.getToken();
  }
}
