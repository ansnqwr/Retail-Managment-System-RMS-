import 'package:dio/dio.dart';
import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/Model/AdModel.dart';
import '../Model/ProductCardModel.dart';
import '../Model/StoreCardItem.dart';

class HomeRepository {
  HomeRepository({Dio? dio});

  Future<List<AdModel>> fetchAds() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        AdModel(id: 1, url: '', businessType: 'promo'),
        AdModel(id: 2, url: '', businessType: 'promo'),
        AdModel(id: 3, url: '', businessType: 'promo'),
        AdModel(id: 4, url: '', businessType: 'promo'),
      ];
    } catch (e) {
      throw HomeRepositoryException('Failed to load ads: $e');
    }
  }

  Future<List<CategoryItemModel>> fetchCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        CategoryItemModel(
          id: 1,
          title: 'All',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 2,
          title: 'Clothing',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 3,
          title: 'Electronics',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 4,
          title: 'Sports',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 5,
          title: 'Home',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
        CategoryItemModel(
          id: 6,
          title: 'Jewelry',
          subCategories: [],
          hasSubCategories: false,
          imageUrl: '',
        ),
      ];
    } catch (e) {
      throw HomeRepositoryException('Failed to load categories: $e');
    }
  }

  Future<List<ProductCardModel>> fetchProductsByType(
    String businessType, {
    int limit = 10,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return List.generate(
        limit,
        (i) => ProductCardModel(
          id: i + 1,
          imageUrl: '',
          title: '$businessType ${i + 1}',
          price: 17.99 + (i * 2.5),
          isNew: i == 0,
          hasDiscount: i < 3 && businessType == 'On Sale',
          discountPercentage:
              (i < 3 && businessType == 'On Sale') ? 10 + (i * 5) : 0,
        ),
      );
    } catch (e) {
      throw HomeRepositoryException(
        'Failed to load $businessType products: $e',
      );
    }
  }

  Future<List<StoreCardModel>> fetchStoresByType(
    String storeType, {
    int limit = 10,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      final isBrand = storeType == 'Brands';
      return List.generate(
        limit,
        (i) => StoreCardModel(
          id: i + 1,
          imageUrl: '',
          title: isBrand ? 'Brand Store ${i + 1}' : 'Local Store ${i + 1}',
          isNew: i == 0,
          governorate: 'Damascus',
          city: 'Meedan',
          isVerified: true,
          isBrand: isBrand,
        ),
      );
    } catch (e) {
      throw HomeRepositoryException('Failed to load $storeType stores: $e');
    }
  }

  Future<List<ProductCardModel>> fetchJustForYou({int limit = 10}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return List.generate(
        limit,
        (i) => ProductCardModel(
          id: 100 + i,
          imageUrl: '',
          title: 'Recommended ${i + 1}',
          price: 25.99 + i,
          isNew: i < 2,
          hasDiscount: i % 2 == 0,
          discountPercentage: i % 2 == 0 ? 15 : 0,
        ),
      );
    } catch (e) {
      throw HomeRepositoryException('Failed to load recommendations: $e');
    }
  }

  Future<HomeDataBundle> fetchAllHomeData() async {
    try {
      final results = await Future.wait([
        fetchAds(),
        fetchCategories(),
        fetchProductsByType('Trending'),
        fetchProductsByType('On Sale'),
        fetchProductsByType('Most Bought'),
        fetchProductsByType('Newest'),
        fetchStoresByType('Brands'),
        fetchStoresByType('Stores Nearby'),
        fetchJustForYou(),
      ]);

      return HomeDataBundle(
        ads: results[0] as List<AdModel>,
        categories: results[1] as List<CategoryItemModel>,
        trendingProducts: results[2] as List<ProductCardModel>,
        onSaleProducts: results[3] as List<ProductCardModel>,
        mostBoughtProducts: results[4] as List<ProductCardModel>,
        newestProducts: results[5] as List<ProductCardModel>,
        brandStores: results[6] as List<StoreCardModel>,
        nearbyStores: results[7] as List<StoreCardModel>,
        justForYouProducts: results[8] as List<ProductCardModel>,
      );
    } catch (e) {
      throw HomeRepositoryException('Failed to load home data: $e');
    }
  }

  Future<List<ProductCardModel>> fetchProductsByCategory(int categoryId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return List.generate(
        8,
        (i) => ProductCardModel(
          id: 200 + i,
          imageUrl: '',
          title: 'Category $categoryId Product ${i + 1}',
          price: 19.99 + i,
          isNew: false,
          hasDiscount: false,
          discountPercentage: 0,
        ),
      );
    } catch (e) {
      throw HomeRepositoryException('Failed to load category products: $e');
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

// import 'package:dio/dio.dart';
// import '../../auth/data/models/Repository/signin_repository.dart';
// import '../Model/ProductCardModel.dart';
// import '../Model/StoreCardItem.dart';
// import '/features/categories/Model/CategoryItemModel.dart';
// import '/features/home/Model/AdModel.dart';

// class HomeRepository {
//   final Dio _dio;

//   HomeRepository({Dio? dio})
//     : _dio =
//           dio ??
//           Dio(
//             BaseOptions(
//               baseUrl: baseUrl,
//               connectTimeout: const Duration(seconds: 10),
//               receiveTimeout: const Duration(seconds: 10),
//               headers: {
//                 'Content-Type': 'application/json',
//                 'Accept': 'application/json',
//                 // 'Authorization': 'Bearer $token',
//               },
//             ),
//           );

//   Future<List<CategoryItemModel>> fetchCategories() async {
//     try {
//       final response = await _dio.get('/categories');

//       // Parse the JSON array
//       final List<dynamic> data = response.data;
//       return data.map((json) => CategoryItemModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load categories: $e');
//     }
//   }

//   Future<List<AdModel>> fetchAds() async {
//     try {
//       final response = await _dio.get('/ads');
//       final List<dynamic> data = response.data;
//       return data.map((json) => AdModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load ads: $e');
//     }
//   }

//   Future<List<ProductCardModel>> fetchProductsByType(
//     String businessType, {
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/products',
//         queryParameters: {'type': businessType, 'limit': limit},
//       );

//       final List<dynamic> data = response.data;
//       return data.map((json) => ProductCardModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException(
//         'Failed to load $businessType products: $e',
//       );
//     }
//   }

//   Future<List<ProductCardModel>> fetchProductsByCategory(int categoryId) async {
//     try {
//       final response = await _dio.get(
//         '/products',
//         queryParameters: {'categoryId': categoryId},
//       );

//       final List<dynamic> data = response.data;
//       return data.map((json) => ProductCardModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load category products: $e');
//     }
//   }

//   Future<List<ProductCardModel>> fetchJustForYou({int limit = 10}) async {
//     try {
//       final response = await _dio.get(
//         '/products/recommended',
//         queryParameters: {'limit': limit},
//       );

//       final List<dynamic> data = response.data;
//       return data.map((json) => ProductCardModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load recommendations: $e');
//     }
//   }

//   Future<List<StoreCardModel>> fetchStoresByType(
//     String storeType, {
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/stores',
//         queryParameters: {'type': storeType, 'limit': limit},
//       );

//       final List<dynamic> data = response.data;
//       return data.map((json) => StoreCardModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw HomeRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load $storeType stores: $e');
//     }
//   }

//   Future<HomeDataBundle> fetchAllHomeData() async {
//     try {
//       final results = await Future.wait([
//         fetchAds(),
//         fetchCategories(),
//         fetchProductsByType('Trending'),
//         fetchProductsByType('On Sale'),
//         fetchProductsByType('Most Bought'),
//         fetchProductsByType('Newest'),
//         fetchStoresByType('Brands'),
//         fetchStoresByType('Stores Nearby'),
//         fetchJustForYou(),
//       ]);

//       return HomeDataBundle(
//         ads: results[0] as List<AdModel>,
//         categories: results[1] as List<CategoryItemModel>,
//         trendingProducts: results[2] as List<ProductCardModel>,
//         onSaleProducts: results[3] as List<ProductCardModel>,
//         mostBoughtProducts: results[4] as List<ProductCardModel>,
//         newestProducts: results[5] as List<ProductCardModel>,
//         brandStores: results[6] as List<StoreCardModel>,
//         nearbyStores: results[7] as List<StoreCardModel>,
//         justForYouProducts: results[8] as List<ProductCardModel>,
//       );
//     } catch (e) {
//       throw HomeRepositoryException('Failed to load home data: $e');
//     }
//   }

//   String _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return 'Connection timed out. Please check your internet.';
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         if (statusCode == 401) return 'Unauthorized. Please login again.';
//         if (statusCode == 404) return 'Data not found.';
//         if (statusCode == 500) return 'Server error. Please try later.';
//         return 'Server error: $statusCode';
//       case DioExceptionType.connectionError:
//         return 'No internet connection.';
//       default:
//         return 'Network error: ${error.message}';
//     }
//   }
// }

// class HomeDataBundle {
//   final List<AdModel> ads;
//   final List<CategoryItemModel> categories;
//   final List<ProductCardModel> trendingProducts;
//   final List<ProductCardModel> onSaleProducts;
//   final List<ProductCardModel> mostBoughtProducts;
//   final List<ProductCardModel> newestProducts;
//   final List<StoreCardModel> brandStores;
//   final List<StoreCardModel> nearbyStores;
//   final List<ProductCardModel> justForYouProducts;

//   HomeDataBundle({
//     required this.ads,
//     required this.categories,
//     required this.trendingProducts,
//     required this.onSaleProducts,
//     required this.mostBoughtProducts,
//     required this.newestProducts,
//     required this.brandStores,
//     required this.nearbyStores,
//     required this.justForYouProducts,
//   });
// }

// class HomeRepositoryException implements Exception {
//   final String message;
//   HomeRepositoryException(this.message);
//   @override
//   String toString() => message;
// }
