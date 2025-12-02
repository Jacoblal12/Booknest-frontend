import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // since you're on web

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // handle paginated response
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        return data['results'];
      }

      // fallback for non-paginated responses
      if (data is List) return data;

      return [];
    } else {
      throw Exception('Failed to load books');
    }
  }
}
