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
          return handler.next(error);
        },
      ),
    );
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "access", value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "access");
  }
}
