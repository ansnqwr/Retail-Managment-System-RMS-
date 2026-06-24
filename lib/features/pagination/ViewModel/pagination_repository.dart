import '/features/pagination/Model/FiltersModel.dart';
import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/Model/ProductCardModel.dart';
import '/features/home/Model/StoreCardItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../auth/data/models/Repository/auth_local_data.dart';

class PaginationRepository {
  final Dio _dio;
  PaginationRepository({Dio? dio}) : _dio = dio ?? _createDio();

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await TokenManager().loadTokens();
          final token = TokenManager().accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }

  Future<List<ProductCardModel>> fetchProducts({
    required String? businessType,
    required String? searchQuery,
    required Map<String, dynamic> filters,
    required int? subCategoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'businessType': businessType,
        'search': searchQuery,
        'category': filters['category'],
        'subCategory': filters['subCategory'],
        'governorate': filters['governorate'],
        'city': filters['city'],
        'brand': filters['brand'],
        'color': filters['color'],
        'inStock': filters['inStockOnly'],
      };

      final priceRange = filters['priceRange'];
      if (priceRange != null && priceRange is RangeValues) {
        queryParams['minPrice'] = priceRange.start;
        queryParams['maxPrice'] = priceRange.end;
      } else {
        queryParams['minPrice'] = null;
        queryParams['maxPrice'] = null;
      }

      // queryParams.removeWhere((key, value) => value == null);

      print(queryParams);

      final response = await _dio.get(
        '/products',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(_handleDioError(e));
    }
  }

  Future<List<StoreCardModel>> fetchStores({
    required String? businessType,
    required String? searchQuery,
    required Map<String, dynamic> filters,
    required int? subCategoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'businessType': businessType,
        'search': searchQuery,
        'category': filters['category'],
        'subCategory': filters['subCategory'],
        'governorate': filters['governorate'],
        'city': filters['city'],
        'brand': filters['brand'],
      };

      final response = await _dio.get('/stores', queryParameters: queryParams);
      final List<dynamic> data = response.data;

      return data.map((json) => StoreCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(_handleDioError(e));
    }
  }

  Future<List<CategoryItemModel>> fetchSubCategories(int categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId/subcategories');
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(_handleDioError(e));
    }
  }

  Future<FiltersModel> fetchFilters() async {
    try {
      final response = await _dio.get('/filters');
      return FiltersModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw PaginationRepositoryException(_handleDioError(e));
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
        if (statusCode == 401) return 'Unauthorized. Please login again.';
        if (statusCode == 404) return 'Data not found.';
        if (statusCode == 500) return 'Server error. Please try later.';
        return 'Server error: $statusCode';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Network error: ${error.message}';
    }
  }
}

class PaginationRepositoryException implements Exception {
  final String message;
  PaginationRepositoryException(this.message);
  @override
  String toString() => message;
}
