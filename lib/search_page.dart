import 'package:flutter/material.dart';
import 'news.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  final ThemeMode themeMode;

  const SearchPage({super.key, required this.themeMode});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final NewsService _newsService = NewsService();
  Future<List<dynamic>>? _searchResultsFuture;

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResultsFuture = null;
      });
    } else {
      setState(() {
        _searchResultsFuture = _newsService.getSearchNews(query);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search news...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _searchResultsFuture == null
                ? _buildDefaultSuggestions()
                : FutureBuilder<List<dynamic>>(
                    future: _searchResultsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No results found.'),
                        );
                      }
                      final articles = snapshot.data!;
                      return _buildSearchResults(articles);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSuggestions() {
    final defaultSuggestions = [
      'Latest news',
      'Trending topics',
      'Technology',
      'Sports',
      'Entertainment',
    ];

    return ListView.builder(
      itemCount: defaultSuggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(defaultSuggestions[index]),
          onTap: () {
            _searchController.text = defaultSuggestions[index];
            _onSearchChanged(defaultSuggestions[index]);
          },
        );
      },
    );
  }

  Widget _buildSearchResults(List<dynamic> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final title = article['title'] ?? 'No Title';
        final description = article['description'] ?? 'No Description Available';
        final imageUrl = article['urlToImage'] ?? '';
        final url = article['url'];

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: ListTile(
            minTileHeight: 130,
            leading: SizedBox(
              width: 100,
              height: 100,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        );
                      },
                    )
                  : const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              if (url != null) {
                launchUrl(Uri.parse(url));
              }
            },
          ),
        );
      },
    );
  }
}
