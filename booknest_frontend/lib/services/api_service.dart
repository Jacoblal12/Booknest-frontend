import 'dart:io';
import 'package:booknest_frontend/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:jwt_decode/jwt_decode.dart'; // <-- IMPORTANT

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
          print("🔑 Using Token: $token");
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

  static Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        "/auth/token/",
        data: {"username": username.trim(), "password": password.trim()},
      );

      final accessToken = response.data["access"];
      await saveToken(accessToken);

      return true;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final response = await dio.post(
        "/auth/register/",
        data: {"username": username, "password": password, "email": email},
      );

      return {"success": true, "message": response.data["message"]};
    } catch (e) {
      if (e is DioException) {
        return {
          "success": false,
          "message": e.response?.data["error"] ?? "Registration failed",
        };
      }
      return {"success": false, "message": "Unknown error"};
    }
  }


  static Future<bool> signup(
    String username,
    String email,
    String password,
  ) async {
    final result = await ApiService.register(
      username: username,
      email: email,
      password: password,
    );

    return result["success"] == true;
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "access", value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "access");
  }

  static Future<List<Book>> getBooks() async {
    final response = await dio.get("/books/");

    print("📥 Books Response: ${response.data}");

    // FIX: API returns {count, next, previous, results: [...]}
    final List booksJson = response.data["results"];

    return booksJson.map((json) => Book.fromJson(json)).toList();
  }

  static Future<List<Book>> getMyBooks() async {
    final response = await dio.get("/books/my/");

    final List booksJson = response.data["results"];

    return booksJson.map((json) => Book.fromJson(json)).toList();
  }

  static Future<bool> addToWishlist(int bookId) async {
    try {
      await dio.post("/wishlist/", data: {"book": bookId});
      return true;
    } catch (e) {
      print("Wishlist add error: $e");
      return false;
    }
  }

  static Future<bool> removeFromWishlist(int wishlistId) async {
    try {
      await dio.delete("/wishlist/$wishlistId/");
      return true;
    } catch (e) {
      print("Wishlist delete error: $e");
      return false;
    }
  }

  static Future<bool> uploadBook({
    required String title,
    required String author,
    required String description,
    required String availableFor,
    File? imageFile,
    required String isbn,
    required String genre,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "author": author,
        "description": description,
        "available_for": availableFor,
        if (imageFile != null)
          "cover": await MultipartFile.fromFile(
            imageFile.path,
            filename: "cover.jpg",
          ),
      });

      final response = await dio.post("/books/", data: formData);
      print("Uploaded: ${response.data}");

      return true;
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return false;
    }
  }

  static Future<bool> requestBook({
    required int bookId,
    required String requestType,
    String message = "",
  }) async {
    try {
      final response = await dio.post(
        "/book-requests/",
        data: {"book": bookId, "request_type": requestType, "message": message},
      );

      print("Request created: ${response.data}");
      return true;
    } catch (e) {
      print("Request error: $e");
      return false;
    }
  }

  static Future<String?> getUserId() async {
    final token = await _storage.read(key: "access"); // already saved at login
    if (token == null) return null;
    Map<String, dynamic> data = Jwt.parseJwt(token);
    return data["user_id"].toString();
  }
}
