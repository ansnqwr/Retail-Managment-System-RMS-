// cache/cache_healper.dart

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  /// Initializes the SharedPreferences instance.
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Saves data based on its type.
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);
    if (value is double) return await _sharedPreferences.setDouble(key, value);
    if (value is List<String>)
      return await _sharedPreferences.setStringList(key, value);

    throw Exception('Unsupported value type');
  }

  /// Retrieves a value by key. Return type is dynamic.
  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  /// Retrieves a String value by key.
  static String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  /// Removes a specific key.
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  /// Clears all data.
  static Future<bool> clearAllData() async {
    return await _sharedPreferences.clear();
  }

  /// Checks if a key exists.
  static bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }

  // -----------------------------------
  // إضافة دوال تخص PrefUtils (الثيم)
  static const String _themeKey = 'themeData';

  /// حفظ قيمة الثيم
  static Future<bool> setThemeData(String value) async {
    return await saveData(key: _themeKey, value: value);
  }

  /// جلب قيمة الثيم مع قيمة افتراضية 'lightCode'
  static String getThemeData() {
    return getString(key: _themeKey) ?? 'lightCode';
  }

  /// مسح بيانات الثيم فقط
  static Future<bool> clearThemeData() async {
    return await removeData(key: _themeKey);
  }
}
