import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class PrintLogInterceptor extends Interceptor {
  static const logName = 'HTTP';

  final request = AnsiPen()..yellow();
  final success = AnsiPen()..green();
  final error = AnsiPen()..red();

  PrintLogInterceptor() {
    ansiColorDisabled = false;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      request('${DateTime.now()} - [${options.method}] ${options.uri}'),
      name: logName,
    );

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      success(
        '${DateTime.now()} - [${response.requestOptions.method} ${response.statusCode}] ${response.requestOptions.uri}',
      ),
      name: logName,
    );
    if (response.statusCode != 200) {
      log(
        error(response.data.toString()),
        name: logName,
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      log(
        error(
          '${DateTime.now()} - [DIO_ERROR] ${err.response?.statusCode} | ${err.response?.realUri}', //\n${err.response}
        ),
        name: logName,
        //error: err,
      );
    } else {
      log(
        error(
          '${DateTime.now()} - [DIO_ERROR] ${err.message}',
        ),
        name: logName,
        //error: err,
      );
    }
    return super.onError(err, handler);
  }
}
