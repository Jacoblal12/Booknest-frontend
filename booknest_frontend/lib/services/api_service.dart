import 'dart:io';
import 'package:booknest_frontend/models/book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart'; // <-- IMPORTANT

class ApiService {
  static final Dio dio = Dio();
  static final _storage = const FlutterSecureStorage();

  // Platform-safe Base URL (works on Web + Android + PC)
  static final String baseUrl = _detectBaseUrl();
  static final String mediaBaseUrl = _detectBaseUrl();

  static String _detectBaseUrl() {
    if (kIsWeb) {
      // Web must use localhost
      return "http://127.0.0.1:8000/api";
    }

    // For non-web platforms:
    // Android emulator uses 10.0.2.2
    // Windows/macOS/Linux use localhost
    return "http://10.0.2.2:8000/api";
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

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "access", value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "access");
  }

  static Future<List<Book>> getBooks() async {
    try {
      final response = await dio.get("/books/");

      final data = response.data;

      // Works for both [ {...}, {...} ] and { results: [...] }
      final List items = data is Map ? data["results"] ?? [] : data;

      return items.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      print("getBooks ERROR: $e");
      return [];
    }
  }

  static Future<List<Book>> getMyBooks() async {
    try {
      final response = await dio.get("/books/my/");
      final List data = response.data['results'];
      return data.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      print("ERROR fetching my books: $e");
      return [];
    }
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
    File? imageFile, required String isbn, required String genre,
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

}
