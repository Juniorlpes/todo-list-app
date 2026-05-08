import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String> Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['authorization'] = await getToken();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }
}
