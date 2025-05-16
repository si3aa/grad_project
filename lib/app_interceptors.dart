import 'dart:developer';

import 'package:Herfa/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppIntercepters extends Interceptor {
  AppIntercepters();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.xRequested] = AppStrings.xmlHttpRequest;
    options.headers[AppStrings.authorization] =
        "${AppStrings.bearer}eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiTUVSQ0hBTlQiLCJpc3MiOiJlQ29tbWVyY2UiLCJVU0VSTkFNRSI6Im1obWQiLCJleHAiOjE3NDY4OTQxOTJ9.wdfbolRgFJ28Jqskgz6ufmaokxnX11qTHpc2eoeLL0M";

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
