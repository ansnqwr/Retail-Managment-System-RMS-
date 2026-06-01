// auth_repository.dart
// import 'package:dio/dio.dart';

// class AuthRepository {
//   final Dio _dio = Dio(); // أو استخدم مكتبة http

//   Future<void> signup(Map<String, dynamic> userData) async {
//     // استبدل الرابط برابط الـ API الحقيقي الخاص بك
//     final response = await _dio.post(
//       'https://your-api.com/signup',
//       data: userData,
//     );
//     if (response.statusCode != 200) throw Exception("Failed to signup");
//   }
// }
