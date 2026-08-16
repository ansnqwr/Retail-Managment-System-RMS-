import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/models/Repository/auth_local_data.dart';
import '../../auth/data/models/Repository/signin_repository.dart';
import '../model/orderModel.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String orderId);
  Future<void> trackOrder(String orderId);
  Future<void> reviewOrder(String orderId, {String? review, double? rating});
  Future<Order> changeOrderStatus(String orderId, OrderStatus newStatus);
}

class OrdersRepositoryImpl implements OrdersRepository {
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${TokenManager().accessToken ?? ''}',
  };

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey('data')) {
      final inner = data['data'];
      if (inner is List) return inner;
    }
    throw FormatException('Unexpected response shape: $data');
  }

  @override
  Future<List<Order>> getOrders() async {
    print('TOKEN: ${TokenManager().accessToken}'); // ← add this
    final response = await http
        .get(Uri.parse('$baseUrl/orders'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    print('STATUS: ${response.statusCode}'); // ← and this
    print('BODY: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = _asList(jsonDecode(response.body));
      return list
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load orders');
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/orders/$orderId'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    print('getOrderById STATUS: ${response.statusCode}');
    print('getOrderById BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      // Handle both shapes: {"data": {...}} and {"data": [...]}
      Map<String, dynamic> orderJson;
      if (decoded is Map && decoded.containsKey('data')) {
        final inner = decoded['data'];
        if (inner is List) {
          if (inner.isEmpty) throw Exception('Order $orderId not found');
          orderJson = inner.first as Map<String, dynamic>;
        } else {
          orderJson = inner as Map<String, dynamic>;
        }
      } else if (decoded is Map) {
        orderJson = decoded as Map<String, dynamic>;
      } else {
        throw FormatException('Unexpected response shape for order $orderId');
      }

      return Order.fromJson(orderJson);
    }
    throw Exception('Failed to load order details');
  }

  @override
  Future<void> trackOrder(String orderId) async {
    // No endpoint yet — no-op
  }

  @override
  Future<void> reviewOrder(
    String orderId, {
    String? review,
    double? rating,
  }) async {
    // No endpoint yet — no-op
  }

  @override
  Future<Order> changeOrderStatus(String orderId, OrderStatus newStatus) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/qrscan/$orderId'),
          headers: _headers,
          body: jsonEncode({'orderStatus': newStatus.name}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Response is just {"message": "..."}, so fetch the updated order separately
      return getOrderById(orderId);
    }

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Failed to update order status');
  }
}
