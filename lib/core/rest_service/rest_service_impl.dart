import 'package:dio/dio.dart';

import '../app_failure.dart';
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

    for (var interceptor in interceptors) {
      _dio.interceptors.add(interceptor);
    }
  }

  @override
  Future<RestResponse<List<T>>> getList<T>(
    String path,
    T Function(dynamic json) parse, {
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
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<List<T>>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<T>> getModel<T>(
    String path,
    T Function(dynamic json) parse, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final result = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<T>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<List<T>>> postList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
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
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<List<T>>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<T>> postModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse,
  ) async {
    try {
      final result = await _dio.post(path, data: body);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<T>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<T>> putModel<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse,
  ) async {
    try {
      final result = await _dio.put(path, data: body);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode))
        ..data = parse(result.data);
    } on DioException catch (err) {
      return RestResponse<T>(
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<T>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<List<T>>> putList<T>(
    String path,
    dynamic body,
    T Function(dynamic json) parse, {
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
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<List<T>>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<RestResponse<T>> deleteModel<T>(String path) async {
    try {
      final result = await _dio.delete(path);
      return RestResponse<T>(RestStatusCode.fromInt(result.statusCode));
    } on DioException catch (err) {
      return RestResponse<T>(
        RestStatusCode.fromInt(err.response?.statusCode),
        errorMessage: _getErrorMessage(err),
      );
    } catch (e) {
      return RestResponse<T>(
        RestStatusCode.unknow,
        errorMessage: e.toString(),
      );
    }
  }

  String _getErrorMessage(DioException error) {
    final statusCode = RestStatusCode.fromInt(error.response?.statusCode);
    return statusCode.label;
  }

  List<T> _parseList<T>(dynamic items, T Function(dynamic item) parse) =>
      (items as List<dynamic>).map((e) => parse(e)).toList();
}

/// A [NetworkFailure] that carries the REST status code context.
class NetworkFailure extends AppFailure {
  final RestStatusCode statusCode;

  const NetworkFailure({
    required this.statusCode,
    super.message,
  });

  @override
  String toString() => message ?? statusCode.label;
}
