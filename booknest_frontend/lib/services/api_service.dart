import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final Dio dio = Dio();
  static final _storage = const FlutterSecureStorage();

  /// BASE URL auto-chooses correct host
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000/api"; // ✔ Web (Browser)
    }

    // Android emulator uses 10.0.2.2 to reach PC
    return "http://10.0.2.2:8000/api"; // ✔ Android
  }

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
  /// LOGIN METHOD
  /// -----------------------------
  static Future<bool> login(String username, String password) async {
    try {
      print("🔵 Sending login request to → ${dio.options.baseUrl}/auth/token/");
      print("Payload => username: $username, password: $password");

      final response = await dio.post(
        "/auth/token/",
        data: {
          "username": username.trim(),
          "password": password.trim(),
        },
      );

      print("🟢 Response status: ${response.statusCode}");
      print("🟢 Response data: ${response.data}");

      final accessToken = response.data["access"];
      await saveToken(accessToken);

      return true;
    } catch (e) {
      print("🔴 LOGIN ERROR OCCURRED:");
      if (e is DioException) {
        print("Status Code: ${e.response?.statusCode}");
        print("Response: ${e.response?.data}");
      } else {
        print("Error: $e");
      }

      return false;
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
