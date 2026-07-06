import 'package:dio/dio.dart';
import '../../auth/data/models/Repository/signin_repository.dart';
import '../Model/CategoryItemModel.dart';

class CategoryRepository {
  final Dio _dio;

  CategoryRepository({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       await TokenManager().loadTokens();
    //       final token = TokenManager().accessToken;
    //       if (token != null && token.isNotEmpty) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }
    //       handler.next(options);
    //     },
    //   ),
    // );

    return dio;
  }

  Future<List<CategoryItemModel>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');

      final List<dynamic> data = response.data;
      return data.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw CategoriesRepositoryException(_handleDioError(e));
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');
      throw CategoriesRepositoryException('Failed to load categories: $e');
    }
  }
}

String _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out. Please check your internet.';
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      print('Server responded with status: $statusCode');
      print('Response body: $responseData');
      if (statusCode == 401) return 'Unauthorized. Please login again.';
      if (statusCode == 403) return 'Forbidden. You don\'t have permission.';
      if (statusCode == 404) return 'Categories endpoint not found.';
      if (statusCode == 422) {
        return 'Validation error: ${responseData?['message'] ?? 'Invalid request'}';
      }
      if (statusCode == 500) return 'Server error. Please try later.';
      return 'Server error: $statusCode - ${responseData?['message'] ?? error.message}';
    case DioExceptionType.connectionError:
      return 'No internet connection. Please check your network.';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.unknown:
      return 'An unexpected error occurred: ${error.message}';
    default:
      return 'Network error: ${error.message}';
  }
}

class CategoriesRepositoryException implements Exception {
  final String message;
  CategoriesRepositoryException(this.message);
  @override
  String toString() => message;
}
