import 'dart:developer';
import 'package:dio/dio.dart';

class PrintLogInterceptor extends Interceptor {
  static const logName = 'HTTP';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '${DateTime.now()} - [${options.method}] ${options.uri}',
      name: logName,
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '${DateTime.now()} - [${response.requestOptions.method} ${response.statusCode}] ${response.requestOptions.uri}',
      name: logName,
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      log(
        '${DateTime.now()} - [DIO_ERROR] ${err.response?.statusCode} | ${err.response?.realUri}',
        name: logName,
      );
    } else {
      log(
        '${DateTime.now()} - [DIO_ERROR] ${err.message}',
        name: logName,
      );
    }
    return super.onError(err, handler);
  }
}
