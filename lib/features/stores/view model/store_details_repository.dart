import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:http/http.dart' as http;

class StoreDetailsRepository {
  final http.Client _client;

  StoreDetailsRepository(this._client);

  Future<Map<String, dynamic>> getStoreOverview(int storeId) async {
    final response = await _client.get(Uri.parse('$baseUrl/stores/$storeId'));
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
          'limit': '10',
          'sort_by': sortBy,
        },
      );

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب المنتجات: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
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

    
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Response body is empty');
        }

        final Map<String, dynamic> data = json.decode(response.body);

   
        return data;
      } else {
        throw Exception('فشل في جلب ملف المتجر: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }



}
