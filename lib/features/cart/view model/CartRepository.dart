import 'dart:convert';

import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/CartItemModel.dart';

class CartRepository {
  final http.Client _client;
  static const _localKey = 'local_cart_items';

  CartRepository(this._client);

  // دالة مساعدة لجلب الـ access_token من الكاش مع طباعة حالته
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    print('----------------------------------------');
    print(
      '🔑 [Token Check]: ${token != null && token.isNotEmpty ? "Available (Length: ${token.length})" : "NOT FOUND / EMPTY"}',
    );
    print('----------------------------------------');

    return token;
  }

  Future<List<CartItemModel>> getCart() async {
    try {
      final token = await _getAccessToken();
      final response = await _client.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );
      print('📦 [GetCart] Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items =
            (data['items'] as List? ?? data['cart_items'] as List? ?? []);
        return items.map((e) => CartItemModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(
        '⚠️ [GetCart Error] Backend not available, falling back to local: $e',
      );
    }
    return _readLocal();
  }

  Future<List<CartItemModel>> addToCart(CartItemModel item) async {
    print(
      '🛒 [AddToCart Started] Product: ${item.name} (ID: ${item.productId}), Qty: ${item.quantity}',
    );

    try {
      // 1. جلب التوكن لإرساله داخل الـ Body كما في Postman
      final token = await _getAccessToken();

      // بناء الـ Body تماماً مثل Postman (يتضمن access_token, product_id, color, size, quantity)
      final Map<String, dynamic> bodyData = {
        if (token != null && token.isNotEmpty) "access_token": token,
        "product_id": item.productId,
        if (item.colorName != null) "color": item.colorName,
        if (item.size != null) "size": item.size,
        "quantity": item.quantity,
      };

      final requestBody = json.encode(bodyData);
      print('📤 [AddToCart Request Body]: $requestBody');

      // 2. الرابط المطابق لـ Postman وهو /api/cart
      final String requestUrl = '$baseUrl/cart';
      print('🌐 [AddToCart URL]: $requestUrl');

      // 3. إرسال الطلب بطريقة POST
      final response = await _client.post(
        Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('📥 [AddToCart Response Status Code]: ${response.statusCode}');
      print('📥 [AddToCart Response Body]: ${response.body}');

      // 4. التحقق من نجاح الطلب
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final items =
            (data['items'] as List? ?? data['cart_items'] as List? ?? []);
        print(
          '✅ [AddToCart Success]: Added via Backend successfully. Total items: ${items.length}',
        );
        return items.map((e) => CartItemModel.fromJson(e)).toList();
      } else {
        print(
          '❌ [AddToCart Server Error]: Status code is ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      print('⚠️ [AddToCart Exception Caught]: $e');
      print('🔍 [Stack Trace]: $stackTrace');
    }

    // التراجع إلى التخزين المحلي (Local) في حال فشل الاتصال أو السيرفر
    print('💾 [AddToCart Fallback]: Saving item to local storage (Cache)...');
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
    print(
      '✅ [AddToCart Local Success]: Local cart updated. Total local items: ${cart.length}',
    );
    return cart;
  }

  Future<List<CartItemModel>> updateQuantity(
    CartItemModel item,
    int newQuantity,
  ) async {
    if (item.cartItemId != null) {
      try {
        final token = await _getAccessToken();
        final response = await _client.patch(
          Uri.parse('$baseUrl/cart/items/${item.cartItemId}'),
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
          body: json.encode({'quantity': newQuantity}),
        );
        print('🔄 [UpdateQuantity] Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items =
              (data['items'] as List? ?? data['cart_items'] as List? ?? []);
          return items.map((e) => CartItemModel.fromJson(e)).toList();
        }
      } catch (e) {
        print('⚠️ [UpdateQuantity Error]: $e');
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
        final token = await _getAccessToken();
        final response = await _client.delete(
          Uri.parse('$baseUrl/cart/items/${item.cartItemId}'),
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        );
        print('🗑️ [RemoveFromCart] Status Code: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 204) {
          return getCart();
        }
      } catch (e) {
        print('⚠️ [RemoveFromCart Error]: $e');
      }
    }
    final cart = await _readLocal();
    cart.removeWhere((e) => e.isSameVariant(item));
    await _writeLocal(cart);
    return cart;
  }

  Future<void> clearCart() async {
    try {
      final token = await _getAccessToken();
      final response = await _client.delete(
        Uri.parse('$baseUrl/cart'),
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );
      print('🧹 [ClearCart] Status Code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await _writeLocal([]);
        return;
      }
    } catch (e) {
      print('⚠️ [ClearCart Error]: $e');
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
