// auth_local_data.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


// String? currentToken = TokenManager().accessToken;
// print(currentToken); // سيعطيك التوكن الحالي مباشرة من الذاكرة



class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  String? accessToken;
  String? refreshToken;

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    accessToken = access;
    refreshToken = refresh;

    if (kDebugMode) {
      print("========= 🔑 TOKENS RECEIVED =========");
      print("Access Token: $accessToken");
      print("Refresh Token: $refreshToken");
      print("=====================================");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
    await prefs.setBool(
      'isLoggedIn',
      true,
    ); 
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
