// lib/Repository/signin_repository.dart
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'auth_local_data.dart';

final String baseUrl2 = 'http://192.168.175.213:8000';
final String baseUrl = '$baseUrl2/api';

class SigninRepository {
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final String loginUrl = '$baseUrl/auth/login';

    try {
      final response = await http
          .post(
            Uri.parse(loginUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
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
          errorData['message'] ??
              'Email or password is incorrect. Please try again.'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Connection error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } on FormatException {
      throw Exception(
        'Invalid response format: Unable to process the server response.'.tr(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> requestGoogleOtp(String email, String googleId) async {
    final String googleOtpUrl = '$baseUrl/auth/google-login';

    try {
      final response = await http
          .post(
            Uri.parse(googleOtpUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'google_id': googleId}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Google OTP sent successfully.');
        print('Response body: ${response.body.toString()}');
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Server error: Unable to send OTP. Please try again later.'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otpCode) async {
    final String verifyUrl = '$baseUrl/auth/verify-otp';

    try {
      final response = await http
          .post(
            Uri.parse(verifyUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'otp_code': otpCode}),
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
          errorData['message'] ??
              'Verification code is invalid or expired.'.tr(),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendForgotPasswordEmail(String email) async {
    final String forgotPasswordUrl = '$baseUrl/forgot-password';

    try {
      final response = await http
          .post(
            Uri.parse(forgotPasswordUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['status'] == 'success') return;
        throw Exception(
          body['message'] ?? 'Failed to send password reset link'.tr(),
        );
      } else {
        throw Exception(
          body['message'] ?? 'Failed to send password reset link'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:'.tr(), '').trim());
    }
  }

  // signin_repository.dart
  Future<void> verifyForgotPassword(String email, String otpCode) async {
    final String verifyUrl = '$baseUrl/verify-forgot-password';

    try {
      final response = await http
          .post(
            Uri.parse(verifyUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'otp_code': otpCode}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // ✅ Just verify. NO tokens here.
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Verification code is invalid or expired.'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final String resetUrl = '$baseUrl/reset-forgot-password'; // ← FIXED

    try {
      final response = await http
          .post(
            Uri.parse(resetUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'new_password': newPassword,
              'new_password_confirmation':
                  newPassword, // ← BACKEND REQUIRES THIS
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Failed to reset password. Please try again later.'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection'
            .tr(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Add this method inside SigninRepository class

  Future<void> registerGoogleUser({
    required String email,
    required String googleId,
    required String firstName,
    required String lastName,
    required String phone,
    required String governorate,
    required String city,
  }) async {
    // ⚠️ CHANGE THIS PATH TO MATCH YOUR BACKEND
    // If your backend does NOT have a google-signup endpoint yet,
    // replace the body of this method with:
    //    return requestGoogleOtp(email, googleId);
    final String url = '$baseUrl/auth/google-signup';

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'google_id': googleId,
              'first_name': firstName,
              'last_name': lastName,
              'phone_number': phone,
              'governorate': governorate,
              'city': city,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Failed to register Google user. Please try again later.'.tr(),
        );
      }
    } on http.ClientException {
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    final String logoutUrl = '$baseUrl/logout'; // → /api/logout
    final String? token = TokenManager().accessToken;

    try {
      final response = await http
          .post(
            Uri.parse(logoutUrl),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      // We clear tokens regardless of status code
      // (even if the server already invalidated the token)
      await TokenManager().clearTokens();

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        // Optional: log the server message, but still treat logout as successful locally
        try {
          final errorData = jsonDecode(response.body);
          print('Logout server message: ${errorData['message']}');
        } catch (_) {}
      }
    } on http.ClientException {
      // Network error → still clear local tokens
      await TokenManager().clearTokens();
      throw Exception(
        'Network error: Unable to reach the server. Please check your internet connection.'
            .tr(),
      );
    } catch (e) {
      // Any other error → still clear local tokens
      await TokenManager().clearTokens();
      throw Exception(e.toString());
    }
  }
}
