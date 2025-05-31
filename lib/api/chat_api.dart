import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat.dart';

class PostApi {
  static Future<List<Chat>> fetchPosts() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData.map((item) => Chat.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }
}
