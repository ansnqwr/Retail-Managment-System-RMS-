// signup_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/features/auth/view/SignupScreen.dart';
import 'auth_local_data.dart';

class SignupRepository {
  final String _apiBaseUrl = 'https://your-api-url.com';

  Future<void> signup(Map<String, dynamic> userData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_apiBaseUrl/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userData),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final String accessToken =
            responseData['access_token'] ?? responseData['token'] ?? '';
        final String refreshToken = responseData['refresh_token'] ?? '';

        await TokenManager().saveTokens(
          access: accessToken,
          refresh: refreshToken,
        );

        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'فشل التسجيل: تأكد من البيانات',
        );
      }
    } on http.ClientException {
      throw Exception('خطأ في الاتصال بالشبكة، يرجى التحقق من الإنترنت.');
    } on FormatException {
      throw Exception('خطأ في تنسيق البيانات المستلمة من السيرفر.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<List<LocationItem>> getCities() async {
    try {
      final response = await http
          .get(Uri.parse('$_apiBaseUrl/locations/cities'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List data = responseData['data'] ?? [];

        return data
            .map(
              (json) => LocationItem(
                id: json['id'] as int,
                name: json['name'] as String,
              ),
            )
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في جلب المحافظات');
      }
    } catch (e) {
      throw Exception('لم نتمكن من تحميل المحافظات: $e');
    }
  }

  // 3. 🚀 جلب بلدات المحافظة بناءً على الـ ID الخاص بها
  Future<List<LocationItem>> getTowns(int cityId) async {
    try {
      final response = await http
          .get(Uri.parse('$_apiBaseUrl/locations/cities/$cityId/towns'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List data = responseData['data'] ?? [];

        return data
            .map(
              (json) => LocationItem(
                id: json['id'] as int,
                name: json['name'] as String,
              ),
            )
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في جلب البلدات');
      }
    } catch (e) {
      throw Exception('لم نتمكن من تحميل البلدات: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProtectedData() async {
    final String? token = TokenManager().accessToken;

    final response = await http.get(
      Uri.parse('$_apiBaseUrl/protected-route'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
}
