import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // or 10.0.2.2 for emulator

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }
}
