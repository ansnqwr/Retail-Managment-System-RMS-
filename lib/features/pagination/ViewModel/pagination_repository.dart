import '/features/pagination/Model/FiltersModel.dart';
import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/Model/ProductCardModel.dart';
import '/features/home/Model/StoreCardItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  Future<List<ProductCardModel>> fetchProducts({
    int? categoryId, // optional – we prefer filters['category']
    required String? businessType,
    required dynamic searchQuery,
    required Map<String, dynamic> filters,
    required int? subCategoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (businessType != null) queryParams['businessType'] = businessType;
      if (searchQuery != null) {
        if (searchQuery is Map<String, dynamic>) {
          queryParams['search'] = searchQuery;
        } else if (searchQuery.isNotEmpty) {
          queryParams['search'] = searchQuery;
        }
      }
      if (subCategoryId != null) queryParams['subCategoryId'] = subCategoryId;
      if (categoryId != null)
        queryParams['category'] = categoryId; // fallback only

      final filtersModel = filters['filtersModel'] as FiltersModel?;
      final categoryValue = filters['category'];
      final subCategoryName = filters['subCategory'] as String?;
      final governorateName = filters['governorate'] as String?;
      final cityName = filters['city'] as String?;
      final brandName = filters['brand'] as String?;
      final colorName = filters['color'] as String?;
      final inStock = filters['inStockOnly'] as bool?;

      // ---------- Category ----------
      // numeric (from home slider) → send as id
      // string name (from filter sheet) → look up id
      if (categoryValue != null) {
        if (categoryValue is int ||
            (categoryValue is String && int.tryParse(categoryValue) != null)) {
          queryParams['category'] =
              categoryValue is int
                  ? categoryValue
                  : int.parse(categoryValue as String);
        } else if (categoryValue is String) {
          if (filtersModel != null) {
            final id = filtersModel.categoryIdByName(categoryValue);
            if (id != null) queryParams['category'] = id;
          } else {
            queryParams['category'] = categoryValue; // last-resort fallback
          }
        }
      }

      // ---------- Other filters ----------
      if (filtersModel != null) {
        if (subCategoryName != null && categoryValue is String) {
          final id = filtersModel.subcategoryIdByName(
            categoryValue,
            subCategoryName,
          );
          if (id != null) queryParams['subCategory'] = id;
        }
        if (governorateName != null) {
          final id = filtersModel.governorateIdByName(governorateName);
          if (id != null) queryParams['governorate'] = id;
        }
        if (cityName != null && governorateName != null) {
          final id = filtersModel.cityIdByName(governorateName, cityName);
          if (id != null) queryParams['city'] = id;
        }
        if (brandName != null) {
          queryParams['brand'] = brandName;
        }
      } else {
        if (subCategoryName != null)
          queryParams['subCategory'] = subCategoryName;
        if (governorateName != null)
          queryParams['governorate'] = governorateName;
        if (cityName != null) queryParams['city'] = cityName;
        if (brandName != null) queryParams['brand'] = brandName;
      }

      if (colorName != null) queryParams['color'] = colorName;

      // Restore old behaviour
      queryParams['inStock'] = (inStock ?? true) ? 1 : 0;

      final priceRange = filters['priceRange'];
      if (priceRange != null && priceRange is RangeValues) {
        queryParams['minPrice'] = priceRange.start.toInt();
        queryParams['maxPrice'] = priceRange.end.toInt();
      }

      print('PRODUCT QUERY PARAMS: $queryParams');

      final response = await _dio.get(
        '/products/filtered',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(handleDioError(e));
    }
  }

  Future<List<StoreCardModel>> fetchStores({
    int? categoryId, // optional – we prefer filters['category']
    required String? businessType,
    required dynamic searchQuery,
    required Map<String, dynamic> filters,
    required int? subCategoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (businessType != null) queryParams['businessType'] = businessType;
      if (searchQuery != null) {
        if (searchQuery is Map<String, dynamic>) {
          queryParams['search'] = searchQuery;
        } else if (searchQuery.isNotEmpty) {
          queryParams['search'] = searchQuery;
        }
      }
      if (subCategoryId != null) queryParams['subCategoryId'] = subCategoryId;
      if (categoryId != null)
        queryParams['category'] = categoryId; // fallback only

      final filtersModel = filters['filtersModel'] as FiltersModel?;
      final categoryValue = filters['category'];
      final subCategoryName = filters['subCategory'] as String?;
      final governorateName = filters['governorate'] as String?;
      final cityName = filters['city'] as String?;
      final brandName = filters['brand'] as String?;

      // ---------- Category ----------
      if (categoryValue != null) {
        if (categoryValue is int ||
            (categoryValue is String && int.tryParse(categoryValue) != null)) {
          queryParams['category'] =
              categoryValue is int
                  ? categoryValue
                  : int.parse(categoryValue as String);
        } else if (categoryValue is String) {
          if (filtersModel != null) {
            final id = filtersModel.categoryIdByName(categoryValue);
            if (id != null) queryParams['category'] = id;
          } else {
            queryParams['category'] = categoryValue;
          }
        }
      }

      // ---------- Other filters ----------
      if (filtersModel != null) {
        if (subCategoryName != null && categoryValue is String) {
          final id = filtersModel.subcategoryIdByName(
            categoryValue,
            subCategoryName,
          );
          if (id != null) queryParams['subCategory'] = id;
        }
        if (governorateName != null) {
          final id = filtersModel.governorateIdByName(governorateName);
          if (id != null) queryParams['governorate'] = id;
        }
        if (cityName != null && governorateName != null) {
          final id = filtersModel.cityIdByName(governorateName, cityName);
          if (id != null) queryParams['city'] = id;
        }
        if (brandName != null) {
          queryParams['brand'] = brandName;
        }
      } else {
        if (subCategoryName != null)
          queryParams['subCategory'] = subCategoryName;
        if (governorateName != null)
          queryParams['governorate'] = governorateName;
        if (cityName != null) queryParams['city'] = cityName;
        if (brandName != null) queryParams['brand'] = brandName;
      }

      print('STORE QUERY PARAMS: $queryParams');

      final response = await _dio.get(
        '/stores/filtered',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => StoreCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(handleDioError(e));
    }
  }

  Future<List<CategoryItemModel>> fetchSubCategories(int categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId/subcategories');
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw PaginationRepositoryException(handleDioError(e));
    }
  }

  Future<FiltersModel> fetchFilters() async {
    try {
      final response = await _dio.get('/filters/options');
      return FiltersModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw PaginationRepositoryException(handleDioError(e));
    }
  }

  String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Unauthorized. Please login again.';
        if (statusCode == 404) return 'Data not found.';
        if (statusCode == 422) {
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            return 'Validation error: ${data['message'] ?? data.toString()}';
          }
          return 'Invalid request data. Please check your filters.';
        }
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
