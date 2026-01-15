import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    final success = await ApiService.login(username, password);

    isLoading = false;
    notifyListeners();

    return success;
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    isLoggedIn = false;
    notifyListeners();
  }
}
