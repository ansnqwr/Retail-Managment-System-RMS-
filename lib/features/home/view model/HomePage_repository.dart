import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../auth/data/models/Repository/signin_repository.dart';
import '../Model/ProductCardModel.dart';
import '../Model/StoreCardItem.dart';
import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/Model/AdModel.dart';

class HomeRepository {
  final Dio _dio;

  HomeRepository({Dio? dio}) : _dio = dio ?? _createDio();

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

  Future<List<AdModel>> fetchAds() async {
    try {
      final response = await _dio.get('/ads');
      final List<dynamic> data = response.data;
      return data.map((json) => AdModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw HomeRepositoryException(_handleDioError(e));
    } catch (e) {
      throw HomeRepositoryException('Failed to load ads: $e');
    }
  }

  Future<List<CategoryItemModel>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories/home');
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw HomeRepositoryException(_handleDioError(e));
    } catch (e) {
      throw HomeRepositoryException('Failed to load categories: $e');
    }
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

      // For filters, check null before adding:
      if (filters['category'] != null) {
        queryParams['category'] = filters['category'];
      }
      if (filters['subCategory'] != null) {
        queryParams['subCategory'] = filters['subCategory'];
      }
      if (filters['governorate'] != null) {
        queryParams['governorate'] = filters['governorate'];
      }
      if (filters['city'] != null) queryParams['city'] = filters['city'];
      if (filters['brand'] != null) queryParams['brand'] = filters['brand'];
      if (filters['color'] != null) queryParams['color'] = filters['color'];
      if (filters['inStockOnly'] == true) queryParams['inStock'] = true;

      final priceRange = filters['priceRange'];
      if (priceRange != null && priceRange is RangeValues) {
        queryParams['minPrice'] = priceRange.start;
        queryParams['maxPrice'] = priceRange.end;
      } else {
        queryParams['minPrice'] = null;
        queryParams['maxPrice'] = null;
      }

      final response = await _dio.get(
        '/products/filtered',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw HomeRepositoryException(_handleDioError(e));
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

      // For filters, check null before adding:
      if (filters['category'] != null) {
        queryParams['category'] = filters['category'];
      }
      if (filters['subCategory'] != null) {
        queryParams['subCategory'] = filters['subCategory'];
      }
      if (filters['governorate'] != null) {
        queryParams['governorate'] = filters['governorate'];
      }
      if (filters['city'] != null) queryParams['city'] = filters['city'];
      if (filters['brand'] != null) queryParams['brand'] = filters['brand'];
      if (filters['color'] != null) queryParams['color'] = filters['color'];
      if (filters['inStockOnly'] == true) queryParams['inStock'] = true;

      final response = await _dio.get(
        '/stores/filtered',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => StoreCardModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw HomeRepositoryException(_handleDioError(e));
    }
  }

  Future<HomeDataBundle> fetchAllHomeData() async {
    try {
      final results = await Future.wait([
        // fetchAds(), // COMMENTED: backend broken
        fetchCategories(),
        fetchProducts(
          businessType: '<Trending>',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        fetchProducts(
          businessType: 'On Sale',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        // fetchProducts(
        //   businessType: 'Most Bought',
        //   searchQuery: null,
        //   filters: {},
        //   subCategoryId: null,
        //   page: 1,
        //   limit: 10,
        // ),
        fetchProducts(
          businessType: 'Newest',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        fetchStores(
          businessType: 'Brands',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        fetchStores(
          businessType: 'Stores Nearby',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        fetchProducts(
          businessType: 'Just For You',
          searchQuery: null,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
      ]);

      // FIXED: indices aligned with Future.wait results
      // 7 results from Future.wait, mapped to correct fields
      return HomeDataBundle(
        ads: [], // ads fetching broken in backend
        categories: results[0] as List<CategoryItemModel>,
        trendingProducts: results[1] as List<ProductCardModel>,
        onSaleProducts: results[2] as List<ProductCardModel>,
        mostBoughtProducts: [], // COMMENTED in Future.wait
        newestProducts: results[3] as List<ProductCardModel>,
        brandStores: results[4] as List<StoreCardModel>,
        nearbyStores: results[5] as List<StoreCardModel>,
        justForYouProducts: results[6] as List<ProductCardModel>,
      );
    } catch (e) {
      throw HomeRepositoryException('Failed to load home data: $e');
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

class HomeDataBundle {
  final List<AdModel> ads;
  final List<CategoryItemModel> categories;
  final List<ProductCardModel> trendingProducts;
  final List<ProductCardModel> onSaleProducts;
  final List<ProductCardModel> mostBoughtProducts;
  final List<ProductCardModel> newestProducts;
  final List<StoreCardModel> brandStores;
  final List<StoreCardModel> nearbyStores;
  final List<ProductCardModel> justForYouProducts;

  HomeDataBundle({
    required this.ads,
    required this.categories,
    required this.trendingProducts,
    required this.onSaleProducts,
    required this.mostBoughtProducts,
    required this.newestProducts,
    required this.brandStores,
    required this.nearbyStores,
    required this.justForYouProducts,
  });
}

class HomeRepositoryException implements Exception {
  final String message;
  HomeRepositoryException(this.message);
  @override
  String toString() => message;
}
