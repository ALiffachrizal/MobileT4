import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  final ScrollController _scrollController = ScrollController();
  List<News> _newsList = [];
  bool _loading = true;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _loadNews();

    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 400 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  Future<void> _loadNews() async {
    setState(() => _loading = true);
    try {
      final news = await _newsService.fetchNews();
      setState(() => _newsList = news);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat berita: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.apple, color: Colors.black),
            SizedBox(width: 8),
            Text('Berita Hari Ini', style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadNews,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: true,
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _newsList.length,
                  itemBuilder: (context, index) {
                    return NewsTile(news: _newsList[index]);
                  },
                ),
              ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
