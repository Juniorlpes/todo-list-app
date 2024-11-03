import '../general_app_failure.dart';

class WebResponse<T> {
  late T data;
  GeneralAppFailure? failure;

  int? statusCode; //if you are using http service

  bool get success => failure == null;
}

abstract class WebService {
  ///Get a model from webService
  Future<WebResponse<T>> getModel<T>(
    String path,
    //esses dynamic json poderia ser/são Map<String, dynamic>?
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Get a list model from webService
  Future<WebResponse<List<T>>> getList<T>(
    String path,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Post a data and receive a model
  Future<WebResponse<T>> postModel<T>(
      String path, dynamic body, T Function(dynamic json) parse);

  ///Post a data and receive a list model
  Future<WebResponse<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Put a data and receive a model
  Future<WebResponse<T>> putModel<T>(
      String path, dynamic body, T Function(dynamic json) parse);

  ///Post a data and receive a list model
  Future<WebResponse<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  });

  ///Delete a model
  Future<WebResponse<T>> deleteModel<T>(String path);
}
