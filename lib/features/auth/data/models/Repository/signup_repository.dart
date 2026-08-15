import 'dart:convert';
import 'package:http/http.dart' as http;
import '/features/auth/view/SignupScreen.dart';
import '/features/auth/data/models/Repository/signin_repository.dart';
import 'auth_local_data.dart';

class SignupRepository {
  Future<void> signup(Map<String, dynamic> userData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userData),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
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
          errorData['message'] ?? 'Failed to sign up. Please try again later.',
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.',
      );
    } on FormatException {
      throw Exception('Network error: Unable to process the server response.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<List<LocationItem>> getGovernorates() async {
    try {
      print('جاري جلب المحافظات...');

      final response = await http
          .get(Uri.parse('$baseUrl/locations/governorates'))
          .timeout(const Duration(seconds: 10));

      print('Governorates Response status: ${response.statusCode}');
      print('Governorates Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        print('عدد المحافظات: ${responseData.length}');

        return responseData
            .map(
              (json) => LocationItem(
                id: json['id'] as int,
                name: json['name'] as String,
              ),
            )
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get governorates');
      }
    } catch (e) {
      print('خطأ في getGovernorates: $e');
      throw Exception('لم نتمكن من تحميل المحافظات: $e');
    }
  }

  Future<List<LocationItem>> getCities(int governorateId) async {
    try {
      print('جاري جلب المدن للمحافظة رقم: $governorateId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/locations/governorates/$governorateId/cities'),
          )
          .timeout(const Duration(seconds: 10));

      print('Cities Response status: ${response.statusCode}');
      print('Cities Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        print('عدد المدن: ${responseData.length}');

        return responseData
            .map(
              (json) => LocationItem(
                id: json['id'] as int,
                name: json['name'] as String,
              ),
            )
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get cities');
      }
    } catch (e) {
      print('خطأ في getCities: $e');
      throw Exception('لم نتمكن من تحميل البلدات: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProtectedData() async {
    final String? token = TokenManager().accessToken;

    final response = await http.get(
      Uri.parse('$baseUrl/protected-route'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
}
