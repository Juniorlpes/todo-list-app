import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dio_interceptors/auth_interceptor.dart';
import 'dio_interceptors/print_log_interceptor.dart';
import '../general_app_failure.dart';
import 'rest_status_code.dart';
import 'web_service.dart';

//Monitorar performance pode ficar no datasource
class WebServiceImpl implements WebService {
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  WebServiceImpl(
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

  factory WebServiceImpl.todoApi() => WebServiceImpl(
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
  Future<WebResponse<List<T>>> getList<T>(
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
      return WebResponse<List<T>>()..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return WebResponse<List<T>>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<List<T>>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<T>> getModel<T>(
    String path,
    T Function(Map<String, dynamic>? json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(path, queryParameters: query);
      return WebResponse<T>()..data = parse(result.data);
    } on DioException catch (err) {
      return WebResponse<T>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<T>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<List<T>>> postList<T>(
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
      return WebResponse<List<T>>()..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return WebResponse<List<T>>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<List<T>>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<T>> postModel<T>(
      String path, body, T Function(Map<String, dynamic>? json) parse) async {
    try {
      final result = await _dio.post(path, data: body);
      return WebResponse<T>()..data = parse(result.data);
    } on DioException catch (err) {
      return WebResponse<T>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<T>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<T>> putModel<T>(
      String path, body, T Function(dynamic json) parse) async {
    try {
      final result = await _dio.put(path, data: body);
      return WebResponse<T>()..data = parse(result.data);
    } on DioException catch (err) {
      return WebResponse<T>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<T>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<List<T>>> putList<T>(
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
      return WebResponse<List<T>>()..data = _parseList(result.data, parse);
    } on DioException catch (err) {
      return WebResponse<List<T>>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<List<T>>()..failure = GeneralAppFailure();
    }
  }

  @override
  Future<WebResponse<T>> deleteModel<T>(String path) async {
    try {
      await _dio.delete(path);
      return WebResponse<T>();
    } on DioException catch (err) {
      return WebResponse<T>()
        ..failure = _getFailureFromDioError(err)
        ..statusCode = err.response?.statusCode;
    } catch (e) {
      return WebResponse<T>()..failure = GeneralAppFailure();
    }
  }

  //Esse tratamento de erro pode de ser revisado e mudado se preciso, add messagem da api etc
  GeneralAppFailure _getFailureFromDioError(DioException error) {
    if (error.response == null) {
      return GeneralAppFailure(
        statusCode: RestStatusCode.fromInt(error.response?.statusCode ?? 0),
      );
    }
    switch (error.response?.statusCode) {
      case 404:
        return GeneralAppFailure(
          statusCode: RestStatusCode.fromInt(error.response?.statusCode ?? 0),
        );
      case 500:
        return GeneralAppFailure(
          statusCode: RestStatusCode.fromInt(error.response?.statusCode ?? 0),
        );
      case 400:
      case 401:
        return GeneralAppFailure(
          statusCode: RestStatusCode.fromInt(error.response?.statusCode ?? 0),
        );
      default:
        return GeneralAppFailure(
          message: 'Unknown',
          statusCode: RestStatusCode.fromInt(error.response?.statusCode ?? 0),
        );
    }
  }

  List<T> _parseList<T>(
          dynamic itens, T Function(Map<String, dynamic>? item) parse) =>
      (itens as List<dynamic>).map((e) => parse(e)).toList();
}
