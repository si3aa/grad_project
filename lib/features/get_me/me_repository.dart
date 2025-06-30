import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/get_me/my_user_model.dart';

class MeRepository {
  final Dio _dio;
  final AuthSharedPrefLocalDataSource _authDataSource =
      AuthSharedPrefLocalDataSource();

  MeRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Data?> getMe() async {
    try {
      final token = await _authDataSource.getToken();
      if (token == null) {
        print('No authentication token found.');
        return null;
      }

      final response = await _dio.get(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('Raw /auth/me response: \\${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final myUserResponse = myUser.fromJson(response.data);
        if (myUserResponse.success == true && myUserResponse.data != null) {
          return myUserResponse.data;
        } else {
          print(
              'API response indicates failure or no data: \\${myUserResponse.message}');
          return null;
        }
      } else {
        print('Failed to fetch user data: \\${response.statusCode}');
        return null;
      }
    } catch (e, stack) {
      print('Error fetching user data: \\${e}');
      print(stack);
      return null;
    }
  }
}
