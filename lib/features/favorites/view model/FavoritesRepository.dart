// lib/features/favorites/data/repositories/favorites_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import '../../auth/data/models/Repository/auth_local_data.dart';
import '../model/favoritesModel.dart';

class FavoritesRepository {
  final http.Client _client;
  static const _localKey = 'local_favorite_product_ids';

  FavoritesRepository(this._client);

  Map<String, String> get _authHeaders {
    final token = TokenManager().accessToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /api/wishlist
  Future<List<Product>> getWishlist() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/wishlist'), headers: _authHeaders)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data['wishlistedProducts'] as List? ?? []);
        final products =
            list
                .map((e) => Product.fromJson(e as Map<String, dynamic>))
                .toList();

        // keep local IDs in sync
        final ids = products.map((p) => p.id).toSet();
        await _writeLocal(ids);

        return products;
      }
      throw Exception('Failed to load wishlist (${response.statusCode})');
    } catch (e) {
      // fallback to local IDs only (no full product data)
      rethrow;
    }
  }

  /// Convenience: only IDs (used by other screens for heart icons)
  Future<Set<int>> getFavoriteIds() async {
    try {
      final products = await getWishlist();
      return products.map((p) => p.id).toSet();
    } catch (_) {
      return _readLocal();
    }
  }

  /// POST /api/wishlist   body: { "product_id": id }
  Future<void> addToWishlist(int productId) async {
    final response = await _client
        .post(
          Uri.parse('$baseUrl/wishlist'),
          headers: _authHeaders,
          body: jsonEncode({'product_id': productId}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      final msg = _extractError(response);
      throw Exception(msg);
    }

    final ids = await _readLocal();
    ids.add(productId);
    await _writeLocal(ids);
  }

  /// DELETE /api/wishlist/{product_id}
  Future<void> removeFromWishlist(int productId) async {
    final response = await _client
        .delete(
          Uri.parse('$baseUrl/wishlist/$productId'),
          headers: _authHeaders,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      final msg = _extractError(response);
      throw Exception(msg);
    }

    final ids = await _readLocal();
    ids.remove(productId);
    await _writeLocal(ids);
  }

  /// Toggle helper used by the BLoC
  Future<bool> toggleFavorite(int productId, bool currentlyFavorite) async {
    if (currentlyFavorite) {
      await removeFromWishlist(productId);
      return false;
    } else {
      await addToWishlist(productId);
      return true;
    }
  }

  // ---------- local cache helpers ----------
  Future<Set<int>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_localKey) ?? [];
    return list.map(int.parse).toSet();
  }

  Future<void> _writeLocal(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_localKey, ids.map((e) => e.toString()).toList());
  }

  String _extractError(http.Response response) {
    try {
      final data = json.decode(response.body);
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Request failed';
    } catch (_) {
      return 'Request failed (${response.statusCode})';
    }
  }
}
