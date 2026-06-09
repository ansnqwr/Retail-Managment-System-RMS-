import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  String? accessToken;
  String? refreshToken;

  // Save both tokens (Used during Login)
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    accessToken = access;
    refreshToken = refresh;

    if (kDebugMode) {
      print("========= 🔑 TOKENS SAVED =========");
      print("Access Token: $accessToken");
      print("Refresh Token: $refreshToken");
      print("===================================");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
    await prefs.setBool('isLoggedIn', true);
  }

  // Save ONLY access token (Used after Refresh Token API call)
  Future<void> saveAccessToken(String access) async {
    accessToken = access;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);

    if (kDebugMode) {
      print("========= 🔄 ACCESS TOKEN UPDATED =========");
      print("New Access Token: $accessToken");
      print("===========================================");
    }
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');
  }

  Future<void> clearTokens() async {
    accessToken = null;
    refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
