import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  final String apiKey =
      'AIzaSyBExbHUfMamOumzIQKNhs8nB6WSvZEkpAc'; // Your API key
  final String cx = 'd4cf937c27d044906'; // Replace with your search engine ID

  Future<List<dynamic>> search(String query) async {
    final url = Uri.parse(
      'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cx&q=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
