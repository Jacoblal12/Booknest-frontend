import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.dio.post(
        "/auth/token/",
        data: {
          "username": username,
          "password": password,
        },
      );

      final token = response.data["access"];
      await ApiService.saveToken(token);

      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    isLoggedIn = false;
    notifyListeners();
  }
}
