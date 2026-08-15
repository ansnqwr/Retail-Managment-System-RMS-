// lib/features/products/view model/ProductDetailsRepository.dart
import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:http/http.dart' as http;
import 'package:delni_rms/features/products/model/ProductDetailModel.dart';
import 'package:delni_rms/features/products/model/ProductReviewModel.dart';

class ProductDetailsRepository {
  final http.Client _client;
  ProductDetailsRepository(this._client);

  // ═══════════════════════════════════════════════════════════════
  // 1. GET /api/products/{id}
  // ───────────────────────────────────────────────────────────────
  // Response 200:
  // {
  //   "product_id": 1,
  //   "name": "Samsung Galaxy S24 Ultra",
  //   "brand": { "id": 1, "name": "Samsung" },
  //   "description": "...",
  //   "price": 18500000,
  //   "old_price": 19000000,
  //   "discount_percentage": 2,
  //   "currency": "Rs.",
  //   "average_rating": 4.9,
  //   "stock_count": 12,
  //   "is_in_stock": true,
  //   "is_favorite": false,
  //   "images": [ { "id": 1, "image_url": "http://..." } ],
  //   "sku": {
  //     "colors": ["Titanium Black", "Titanium Gray"],
  //     "Size": ["256GB", "512GB"]
  //   },
  //   "specifications": { "os": "Android 14", ... },
  //   "story": {
  //     "how_it_was_made": "...",
  //     "manufacturing_info": "..."
  //   }
  // }
  // ═══════════════════════════════════════════════════════════════
  Future<ProductDetailModel> getProductDetails(int productId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/products/$productId'),
    );
    if (response.statusCode == 200) {
      return ProductDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 2. POST /api/products/{id}/variant
  // ───────────────────────────────────────────────────────────────
  // Request:
  // {
  //   "sku_selection": {
  //     "colors": "Titanium Black",
  //     "Size": "256GB"
  //   }
  // }
  //
  // Response 200 — Same shape as GET /products/{id}
  // {
  //   "product_id": 1,
  //   "name": "Samsung Galaxy S24 Ultra",
  //   "price": 18500000,
  //   "stock_count": 3,
  //   "is_in_stock": true,
  //   "images": [ { "id": 101, "image_url": "http://.../black_256.png" } ],
  //   "sku": { "colors": [...], "Size": [...] },
  //   ...
  // }
  // ═══════════════════════════════════════════════════════════════
  Future<ProductDetailModel> getProductVariant(
    int productId,
    Map<String, String> skuSelection,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/products/$productId/sku'), // ← was /variant
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'sku_selection': skuSelection}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Attach image_index into the map so the Bloc can read it
      return ProductDetailModel.fromJson(data);
    } else {
      throw Exception(
        'Variant not found or invalid SKU selection (${response.statusCode})',
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 3. GET /api/products/{id}/reviews?page=1&limit=5
  // ───────────────────────────────────────────────────────────────
  // Response 200:
  // {
  //   "average_rating": 5,
  //   "verified_buyers": 2,
  //   "total_reviews": 2,
  //   "has_more": false,
  //   "reviews": [
  //     {
  //       "review_id": 4,
  //       "user_name": "Ahmad",
  //       "user_image": "",
  //       "rating": 5,
  //       "comment": "...",
  //       "images": [],
  //       "created_at": "2026-08-15",
  //       "fit_tag": "True to Size"
  //     }
  //   ]
  // }
  // ═══════════════════════════════════════════════════════════════
  Future<ProductReviewsResponse> getProductReviews(
    int productId, {
    int page = 1,
    int limit = 5,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/products/$productId/reviews?page=$page&limit=$limit'),
    );
    if (response.statusCode == 200) {
      return ProductReviewsResponse.fromJson(json.decode(response.body));
    } else {
      return ProductReviewsResponse(
        averageRating: 0,
        verifiedBuyers: 0,
        totalReviews: 0,
        reviews: [],
        hasMore: false,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 4. GET /api/products/{id}/similar
  // ───────────────────────────────────────────────────────────────
  // Response 200:
  // {
  //   "similar_products": [
  //     {
  //       "id": 9,
  //       "name": "طقم ذهب عيار 21 ...",
  //       "price": 45000000,
  //       "old_price": 45000000,
  //       "discount_percentage": 0,
  //       "currency": "Rs.",
  //       "average_rating": 5,
  //       "image_url": "http://.../earrings.png"
  //     }
  //   ]
  // }
  // ═══════════════════════════════════════════════════════════════
  Future<List<SimilarProductModel>> getSimilarProducts(int productId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/products/$productId/similar'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['similar_products'] as List? ?? [];
        return list.map((e) => SimilarProductModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  // ═══════════════════════════════════════════════════════════════
  // 5. GET /api/products/{id}/recommended
  // ───────────────────────────────────────────────────────────────
  // Response 200:
  // {
  //   "customers_also_like": [
  //     {
  //       "id": 20,
  //       "name": "طقم كاسات كريستال ...",
  //       "price": 320000,
  //       "old_price": 380000,
  //       "discount_percentage": 15,
  //       "currency": "Rs.",
  //       "average_rating": 4.5,
  //       "image_url": "http://.../crystal_glass.png"
  //     }
  //   ]
  // }
  // ═══════════════════════════════════════════════════════════════
  Future<List<SimilarProductModel>> getRecommendedProducts(
    int productId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/products/$productId/recommended'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['customers_also_like'] as List? ?? [];
        return list.map((e) => SimilarProductModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }
}
