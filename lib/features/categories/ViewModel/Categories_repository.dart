import 'package:dio/dio.dart';
import '../Model/CategoryItemModel.dart';

class CategoryRepository {
  CategoryRepository({Dio? dio});

  Future<List<CategoryItemModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));

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
        hasSubCategories: true,
        imageUrl: '',
        subCategories: [
          CategoryItemModel(
            id: 21,
            title: 'Shoes',
            subCategories: [],
            hasSubCategories: false,
            imageUrl: '',
          ),
          CategoryItemModel(
            id: 22,
            title: 'Hats',
            subCategories: [],
            hasSubCategories: false,
            imageUrl: '',
          ),
          CategoryItemModel(
            id: 23,
            title: 'Pants',
            subCategories: [],
            hasSubCategories: false,
            imageUrl: '',
          ),
          CategoryItemModel(
            id: 24,
            title: 'Shirts',
            subCategories: [],
            hasSubCategories: false,
            imageUrl: '',
          ),
        ],
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
  }
}

class CategoriesRepositoryException implements Exception {
  final String message;
  CategoriesRepositoryException(this.message);
  @override
  String toString() => message;
}

// ============================================
// REAL API REPOSITORY — Uncomment when backend is ready
// ============================================
/*
class CategoryRepository {
  final Dio _dio;

  CategoryRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://your-api.com/api',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  // 'Authorization': 'Bearer $token',
                },
              ),
            );

  Future<List<CategoryItemModel>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');

      // API returns: [{id, title, subCategories, hasSubCategories, imageUrl}, ...]
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw CategoriesRepositoryException(_handleDioError(e));
    } catch (e) {
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

class CategoriesRepositoryException implements Exception {
  final String message;
  CategoriesRepositoryException(this.message);
  @override
  String toString() => message;
}


*/
