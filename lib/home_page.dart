import 'package:flutter/material.dart';
import 'news.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const HomePage(
      {super.key, required this.themeMode, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();

  late Future<List<dynamic>> _topNewsFuture = _newsService.getTopNews();

  @override
  void initState() {
    super.initState();
    _topNewsFuture = _newsService.getTopNews();
  }

  void _navigateToUrl(BuildContext context, String? url) {
    if (url != null && url.isNotEmpty) {
      // Use the `url_launcher` package to open the URL
      launchUrl(Uri.parse(url));
    } else {
      // Show a SnackBar if the URL is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: URL not available'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News MunchXX'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // print(_topNewsFuture);
              _topNewsFuture.then((value) {
                print(value); // Now you can access the value with an index
              });
            },
          ),
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            width: 200,
            height: 200,
            child: FlutterLogo(),
          ),
          FutureBuilder<List<dynamic>>(
            future: _topNewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final article = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: article.length,
                  itemBuilder: (context, index) {
                    final news = article[index];
                    final imageUrl = news['urlToImage'] ?? '';
                    final title = news['title'] ?? 'No Title';
                    final description =
                        news['description'] ?? 'No Description Available';
                    final publishedAt = news['publishedAt'] ?? '';
                    final newsurl = news['url'];
                    String formattedDate = '';
                    if (publishedAt.isNotEmpty) {
                      try {
                        final dateTime = DateTime.parse(publishedAt);
                        formattedDate =
                            DateFormat.yMMMd().add_jm().format(dateTime);
                      } catch (e) {
                        formattedDate = 'Invalid Date';
                      }
                    }
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8), // Rounded corners for the image
                          child: Image.network(
                            imageUrl,
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // Image has fully loaded
                              }
                              return const Center(
                                child:
                                    CircularProgressIndicator(), // Show loading indicator
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors
                                    .grey, // Display a dummy icon if the image fails
                              );
                            },
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        isThreeLine: true,
                      onTap: () => _navigateToUrl(context, newsurl),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
