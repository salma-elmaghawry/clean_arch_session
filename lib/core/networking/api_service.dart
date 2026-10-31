import 'package:clean_arch_session/core/cache/cache_const.dart';
import 'package:clean_arch_session/core/cache/cache_helper.dart';
import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio) {
    dio.options.baseUrl = ApiConstants.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.headers = {
      'Accept': 'application/json',
      'x-api-key': ApiConstants.apiKey,
    };
    dio.interceptors.add(InterceptorsWrapper(onRequest: _addToken));
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<void> _addToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await CacheHelper.getSecureData(
      key: CacheConstants.userToken,
    );
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<Response> post(String endpoint, {Object? data}) async {
    return await dio.post(endpoint, data: data);
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> put(String endpoint, {Object? data}) async {
    return await dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {Object? data}) async {
    return await dio.delete(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, {Object? data}) async {
    return await dio.patch(endpoint, data: data);
  }
}
