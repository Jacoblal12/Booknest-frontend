import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final Dio dio = Dio();
  static final _storage = const FlutterSecureStorage();

  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<void> init() async {
    dio.options.baseUrl = baseUrl;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: "access");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print("API ERROR: ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );
  }

  /// -----------------------------
  /// LOGIN METHOD (important)
  /// -----------------------------
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    try {
      final response = await dio.post(
        "/auth/token/",
        data: jsonEncode({
          "username": username.trim(),
          "password": password.trim(),
        }),
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      return response.data;
    } catch (e) {
      if (e is DioError) {
        print("LOGIN ERROR: ${e.response?.data}");
      } else {
        print("LOGIN ERROR: $e");
      }
      return null;
    }
  }

  /// Save access token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: "access", value: token);
  }

  /// Clear token
  static Future<void> clearToken() async {
    await _storage.delete(key: "access");
  }
}
