// core1/api/dio_consumer.dart

import 'package:delni_rms/core1/api/api_consumer.dart';
import 'package:delni_rms/core1/api/api_interceptors.dart';
import 'package:delni_rms/core1/errors/exception.dart';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart'
    as EndPoints;
import 'package:dio/dio.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool isFromData = false,
    bool requiresLocale = true,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: {
            'requiresToken': requiresToken,
            'requiresLocale': requiresLocale,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: {
            'requiresToken': requiresToken,
            'requiresLocale': requiresLocale,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: {
            'requiresToken': requiresToken,
            'requiresLocale': requiresLocale,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: {
            'requiresToken': requiresToken,
            'requiresLocale': requiresLocale,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: {
            'requiresToken': requiresToken,
            'requiresLocale': requiresLocale,
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }
}
