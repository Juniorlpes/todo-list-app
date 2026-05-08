import 'rest_status_code.dart';

class RestResponse<T> {
  late T data;
  final RestStatusCode statusCode;
  final String? errorMessage;

  RestResponse(this.statusCode, {this.errorMessage});

  bool get success => errorMessage == null;
}

abstract class RestService {
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<RestResponse<T>> postModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse,
  );

  Future<RestResponse<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<RestResponse<T>> putModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse,
  );

  Future<RestResponse<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  Future<RestResponse<T>> deleteModel<T>(String path);
}
