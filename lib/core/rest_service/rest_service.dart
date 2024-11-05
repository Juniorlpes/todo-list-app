import '../general_app_failure.dart';
import 'rest_status_code.dart';

class RestResponse<T> {
  late T data;
  GeneralAppFailure? failure;

  final RestStatusCode statusCode;

  RestResponse(this.statusCode);

  bool get success => failure == null;
}

abstract class RestService {
  ///Get a model from webService
  Future<RestResponse<T>> getModel<T>(
    String path,
    //esses dynamic json poderia ser/são Map<String, dynamic>?
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Get a list model from webService
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Post a data and receive a model
  Future<RestResponse<T>> postModel<T>(
      String path, dynamic body, T Function(dynamic json) parse);

  ///Post a data and receive a list model
  Future<RestResponse<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Put a data and receive a model
  Future<RestResponse<T>> putModel<T>(
      String path, dynamic body, T Function(dynamic json) parse);

  ///Post a data and receive a list model
  Future<RestResponse<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Delete a model
  Future<RestResponse<T>> deleteModel<T>(String path);
}
