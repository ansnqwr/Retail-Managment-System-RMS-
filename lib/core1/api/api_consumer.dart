// core1/api/api_consumer.dart

abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  });

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  });

  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  });
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  });

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
    bool requiresToken = true,
    Map<String, dynamic>? headers,
    bool requiresLocale = true,
  });
}
