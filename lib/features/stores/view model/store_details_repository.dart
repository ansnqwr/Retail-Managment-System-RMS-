import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';

import 'package:http/http.dart' as http;

class StoreDetailsRepository {
  final http.Client _client;

  StoreDetailsRepository(this._client);

  Future<Map<String, dynamic>> getStoreOverview(int storeId) async {
    final response = await _client.get(Uri.parse('$baseUrl/stores/$storeId'));
    print('OVERVIEW STATUS: ${response.statusCode}');
    print('OVERVIEW BODY: ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل في جلب البيانات: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getStoreProducts(
    int storeId,
    int page,
    String sortBy,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/stores/$storeId/products').replace(
        queryParameters: {
          'page': page.toString(),
          'perPage': '10',
          'sort_by': sortBy,
        },
      );
      final response = await _client.get(url);
      print('PRODUCTS STATUS: ${response.statusCode}');
      print('PRODUCTS BODY: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get products: ${response.statusCode}');
      }
    } catch (e) {
      print('PRODUCTS ERROR: $e');
      throw Exception('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> getStoreProfile(int storeId) async {
    try {
      final url = Uri.parse('$baseUrl/stores/$storeId/profile');
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('PROFILE STATUS: ${response.statusCode}');
      print('PROFILE BODY: ${response.body}'); // ← add this

      if (response.statusCode == 200) {
        if (response.body.isEmpty) throw Exception('Response body is empty');
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get store profile: ${response.statusCode}');
      }
    } catch (e) {
      print('PROFILE ERROR: $e'); // ← and this
      throw Exception('Connection failed: $e');
    }
  }
}
