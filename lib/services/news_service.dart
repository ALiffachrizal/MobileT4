import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _apiKey = '588aa23eeed84d75ab05cf9f1688fc22';
  static const String _baseUrl =
      'https://newsapi.org/v2/everything?q=apple&from=2025-10-21&to=2025-10-21&sortBy=popularity';

  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse('$_baseUrl&apiKey=$_apiKey'));

    print('Response code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];

      print('Jumlah artikel: ${articles.length}');
      return articles.map((json) => News.fromJson(json)).toList();
    } else {
      print('Error body: ${response.body}');
      throw Exception('Gagal memuat berita');
    }
  }
}
