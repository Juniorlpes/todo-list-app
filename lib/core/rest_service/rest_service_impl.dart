import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dio_interceptors/auth_interceptor.dart';
import 'dio_interceptors/print_log_interceptor.dart';
import '../general_app_failure.dart';
import 'rest_status_code.dart';
import 'rest_service.dart';

class RestServiceImpl implements RestService {
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  RestServiceImpl(
    String baseUrl, {
    List<Interceptor> interceptors = const [],
  }) {
    _dio.options.baseUrl = baseUrl;

    _dio.interceptors.add(PrintLogInterceptor());

    if (interceptors.isNotEmpty) {
      for (var interceptor in interceptors) {
        _dio.interceptors.add(interceptor);
      }
    }
  }

  factory RestServiceImpl.todoApi() => RestServiceImpl(
        'http://192.168.1.11:3333/api',
        interceptors: [
          AuthInterceptor(
            getToken: () async =>
                (await FirebaseAuth.instance.currentUser?.getIdToken(true)) ??
                '',
          ),
        ],
      );

  @override
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<List<T>>(RestStatusCode.fromInt(result.statusCode))
        ..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return RestResponse<List<T>>(
          RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<List<T>>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(path, queryParameters: query);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<T>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<List<T>>> postList<T>(
    String path,
    body,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.post(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<List<T>>(RestStatusCode.fromInt(result.statusCode))
        ..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return RestResponse<List<T>>(
          RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<List<T>>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<T>> postModel<T>(
      String path, body, T Function(Map<String, dynamic>? json) parse) async {
    try {
      final result = await _dio.post(path, data: body);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<T>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<T>> putModel<T>(
      String path, body, T Function(dynamic json) parse) async {
    try {
      final result = await _dio.put(path, data: body);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<T>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<List<T>>> putList<T>(
    String path,
    body,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.put(
        path,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<List<T>>(RestStatusCode.fromInt(result.statusCode))
        ..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return RestResponse<List<T>>(
          RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<List<T>>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  @override
  Future<RestResponse<T>> deleteModel<T>(String path) async {
    try {
      final result = await _dio.delete(path);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode));
    } on DioException catch (err) {
      return RestResponse<T>(RestStatusCode.fromInt(err.response?.statusCode))
        ..failure = _getFailureFromDioError(err);
    } catch (e) {
      return RestResponse<T>(RestStatusCode.unknow)
        ..failure = GeneralAppFailure();
    }
  }

  //Esse tratamento de erro pode de ser revisado e mudado se preciso, add messagem da api etc
  GeneralAppFailure _getFailureFromDioError(DioException error) {
    if (error.response == null) {
      return GeneralAppFailure(
        message: RestStatusCode.fromInt(error.response?.statusCode).name,
      );
    }
    switch (error.response?.statusCode) {
      case 404:
        return GeneralAppFailure(
          message: RestStatusCode.fromInt(error.response?.statusCode).name,
        );
      case 500:
        return GeneralAppFailure(
          message: RestStatusCode.fromInt(error.response?.statusCode).name,
        );
      case 400:
      case 401:
        return GeneralAppFailure(
          message: RestStatusCode.fromInt(error.response?.statusCode).name,
        );
      default:
        return GeneralAppFailure(
          message: RestStatusCode.fromInt(error.response?.statusCode).name,
        );
    }
  }

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();
}
