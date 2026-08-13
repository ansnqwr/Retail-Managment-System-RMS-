// lib/Repository/signin_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_local_data.dart';

final String baseUrl2 = 'http://192.168.1.6:8000';
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
          errorData['message'] ?? 'خطأ في البريد الإلكتروني أو كلمة المرور',
        );
      }
    } on http.ClientException {
      throw Exception('خطأ في الاتصال بالشبكة، يرجى التحقق من الإنترنت.');
    } on FormatException {
      throw Exception('خطأ في تنسيق البيانات المستلمة من السيرفر.');
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
          errorData['message'] ?? 'فشل السيرفر في إرسال الـ OTP الخاص بجوجل',
        );
      }
    } on http.ClientException {
      throw Exception('خطأ في الشبكة أثناء الاتصال بالسيرفر لإرسال الـ OTP.');
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
        throw Exception(errorData['message'] ?? 'رمز التحقق غير صحيح أو انتهى');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'فشل إرسال رابط استعادة كلمة المرور',
        );
      }
    } on http.ClientException {
      throw Exception('خطأ في الاتصال بالشبكة، تحقق من الإنترنت.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final String resetUrl = '$baseUrl/auth/reset-password';

    try {
      final response = await http
          .post(
            Uri.parse(resetUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'new_password': newPassword}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'فشل في إعادة تعيين كلمة المرور',
        );
      }
    } on http.ClientException {
      throw Exception('خطأ في الاتصال بالشبكة، يرجى التحقق من الإنترنت.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
