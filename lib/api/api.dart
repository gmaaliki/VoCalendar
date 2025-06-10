import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Uri buildUri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    // Add auth headers here if needed
  };

  dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Optional: helper for GET
  Future<dynamic> get(String path) async {
    final response = await http.get(buildUri(path), headers: defaultHeaders);
    return handleResponse(response);
  }

  // Optional: helper for POST
  Future<dynamic> post(String path, dynamic body) async {
    final response = await http.post(
      buildUri(path),
      headers: defaultHeaders,
      body: json.encode(body),
    );
    return handleResponse(response);
  }
}
