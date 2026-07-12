import 'dart:convert';

import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:delni_rms/features/home/Model/CartItemModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CartRepository {
  final http.Client _client;
  static const _localKey = 'local_cart_items';

  CartRepository(this._client);

  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/cart'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = (data['items'] as List? ?? []);
        return items.map((e) => CartItemModel.fromJson(e)).toList();
      }
    } catch (_) {
      // backend not available yet - fall through to local cart
    }
    return _readLocal();
  }

  Future<List<CartItemModel>> addToCart(CartItemModel item) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/cart/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toAddToCartJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final items = (data['items'] as List? ?? []);
        return items.map((e) => CartItemModel.fromJson(e)).toList();
      }
    } catch (_) {
      // fall back to local
    }
    final cart = await _readLocal();
    final existingIndex = cart.indexWhere(
      (existing) => existing.isSameVariant(item),
    );
    if (existingIndex != -1) {
      cart[existingIndex] = cart[existingIndex].copyWith(
        quantity: cart[existingIndex].quantity + item.quantity,
      );
    } else {
      cart.add(item);
    }
    await _writeLocal(cart);
    return cart;
  }

  Future<List<CartItemModel>> updateQuantity(
    CartItemModel item,
    int newQuantity,
  ) async {
    if (item.cartItemId != null) {
      try {
        final response = await _client.patch(
          Uri.parse('$baseUrl/cart/items/${item.cartItemId}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'quantity': newQuantity}),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items = (data['items'] as List? ?? []);
          return items.map((e) => CartItemModel.fromJson(e)).toList();
        }
      } catch (_) {
        // fall back to local
      }
    }
    final cart = await _readLocal();
    final index = cart.indexWhere((e) => e.isSameVariant(item));
    if (index != -1) {
      if (newQuantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index] = cart[index].copyWith(quantity: newQuantity);
      }
    }
    await _writeLocal(cart);
    return cart;
  }

  Future<List<CartItemModel>> removeFromCart(CartItemModel item) async {
    if (item.cartItemId != null) {
      try {
        final response = await _client.delete(
          Uri.parse('$baseUrl/cart/items/${item.cartItemId}'),
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          return getCart();
        }
      } catch (_) {
        // fall back to local
      }
    }
    final cart = await _readLocal();
    cart.removeWhere((e) => e.isSameVariant(item));
    await _writeLocal(cart);
    return cart;
  }

  Future<void> clearCart() async {
    try {
      final response = await _client.delete(Uri.parse('$baseUrl/cart'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        await _writeLocal([]);
        return;
      }
    } catch (_) {
      // fall back to local
    }
    await _writeLocal([]);
  }

  Future<List<CartItemModel>> _readLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localKey);
    if (raw == null || raw.isEmpty) return [];
    final list = json.decode(raw) as List;
    return list
        .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _writeLocal(List<CartItemModel> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(
      cart
          .map(
            (e) => {
              'cart_item_id': e.cartItemId,
              'product_id': e.productId,
              'name': e.name,
              'image_url': e.imageUrl,
              'price': e.price,
              'currency': e.currency,
              'color_id': e.colorId,
              'color_name': e.colorName,
              'color_hex': e.colorHex,
              'size': e.size,
              'quantity': e.quantity,
            },
          )
          .toList(),
    );
    await prefs.setString(_localKey, raw);
  }
}
