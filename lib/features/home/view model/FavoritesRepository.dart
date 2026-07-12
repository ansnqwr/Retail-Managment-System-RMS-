import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FavoritesRepository {
  final http.Client _client;
  static const _localKey = 'local_favorite_product_ids';

  FavoritesRepository(this._client);

  Future<Set<int>> getFavoriteIds() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/favorites'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data['favorites'] as List? ?? []);
        final ids =
            list.map((e) => e is Map ? e['id'] as int : e as int).toSet();
        await _writeLocal(ids);
        return ids;
      }
    } catch (_) {
    }
    return _readLocal();
  }


  Future<bool> toggleFavorite(int productId, bool currentIsFavorite) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/products/$productId/favorite/toggle'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newState = data['is_favorite'] ?? !currentIsFavorite;
        final ids = await _readLocal();
        newState ? ids.add(productId) : ids.remove(productId);
        await _writeLocal(ids);
        return newState;
      }
    } catch (_) {
    }
    final ids = await _readLocal();
    final newState = !currentIsFavorite;
    newState ? ids.add(productId) : ids.remove(productId);
    await _writeLocal(ids);
    return newState;
  }

  Future<Set<int>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_localKey) ?? [];
    return list.map(int.parse).toSet();
  }

  Future<void> _writeLocal(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_localKey, ids.map((e) => e.toString()).toList());
  }
}
