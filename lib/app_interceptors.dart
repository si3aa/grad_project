import 'package:Herfa/app_strings.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppIntercepters extends Interceptor {
  final AuthSharedPrefLocalDataSource _authDataSource;

  AppIntercepters() : _authDataSource = AuthSharedPrefLocalDataSource();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authDataSource.getToken();

    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.xRequested] = AppStrings.xmlHttpRequest;

    if (token != null) {
      options.headers[AppStrings.authorization] = "${AppStrings.bearer}$token";
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
