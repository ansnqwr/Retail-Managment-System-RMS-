// core1/api/api_interceptors.dart
import 'package:delni_rms/cache/cache_healper.dart';
import 'package:delni_rms/core1/api/end_points.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresLocale = options.extra['requiresLocale'] ?? true;
    if (requiresLocale) {
      options.headers[ApiKey.locale] = 'ar';
    }

    final requiresToken = options.extra['requiresToken'] ?? true;

    if (requiresToken) {
      final token = CacheHelper.getData(key: ApiKey.accessToken);
      if (token != null) {
        options.headers[ApiKey.authorization] = 'Bearer $token';
      }
    }

    super.onRequest(options, handler);
  }
}
