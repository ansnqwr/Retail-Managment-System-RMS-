// lib/features/home/view model/ProductDetailsRepository.dart
import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:http/http.dart' as http;
import 'package:delni_rms/features/home/Model/ProductDetailModel.dart';
import 'package:delni_rms/features/home/Model/ProductReviewModel.dart';

class ProductDetailsRepository {
  final http.Client _client;

  ProductDetailsRepository(this._client);

  Future<ProductDetailModel> getProductDetails(int productId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/products/$productId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<ProductReviewsResponse> getProductReviews(
    int productId, {
    int page = 1,
    int limit = 5,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/products/$productId/reviews?page=$page&limit=$limit'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductReviewsResponse.fromJson(data);
    } else {
      return  ProductReviewsResponse(
        averageRating: 0,
        verifiedBuyers: 0,
        totalReviews: 0,
        reviews: [],
        hasMore: false,
      );
    }
  }

  Future<List<SimilarProductModel>> getSimilarProducts(int productId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/products/$productId/similar'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['products'] as List? ?? [];
        return list.map((e) => SimilarProductModel.fromJson(e)).toList();
      }
    } catch (_) {
    }
    return [];
  }

  Future<List<SimilarProductModel>> getRecommendedProducts(
    int productId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/products/$productId/recommended'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['products'] as List? ?? [];
        return list.map((e) => SimilarProductModel.fromJson(e)).toList();
      }
    } catch (_) {
    }
    return [];
  }
}
