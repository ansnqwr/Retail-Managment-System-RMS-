import 'dart:convert';
import 'package:delni_rms/features/auth/data/models/Repository/signin_repository.dart';
import 'package:http/http.dart' as http;
import '/features/auth/data/models/Repository/auth_local_data.dart';
import 'user_model.dart';

class ProfileRepository {
  // Helper: Request with automatic token refresh on 401
  Future<http.Response> _performRequest(
    Future<http.Response> Function() request,
  ) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      bool refreshed = await _refreshToken();
      if (refreshed) {
        response = await request(); // Retry the request
      }
    }
    return response;
  }

  // Helper: Refresh logic
  Future<bool> _refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'), // تأكد من المسار الصحيح للـ Refresh
        body: {'refresh_token': TokenManager().refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await TokenManager().saveAccessToken(data['access_token']);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<UserModel> fetchUserProfile() async {
    final response = await _performRequest(
      () => http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer ${TokenManager().accessToken}',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final response = await _performRequest(
      () => http.put(
        Uri.parse('$baseUrl/profile/update'),
        headers: {
          'Authorization': 'Bearer ${TokenManager().accessToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      ),
    );

    if (response.statusCode == 200) {
      return user;
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _performRequest(
      () => http.post(
        Uri.parse('$baseUrl/profile/change-password'),
        headers: {
          'Authorization': 'Bearer ${TokenManager().accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }

  Future<void> changeEmail(String newEmail, String currentPassword) async {
    final response = await _performRequest(
      () => http.post(
        Uri.parse('$baseUrl/profile/change-email'),
        headers: {
          'Authorization': 'Bearer ${TokenManager().accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'new_email': newEmail,
          'current_password': currentPassword,
        }),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change email');
    }
  }
}
