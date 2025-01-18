import 'package:flutter/material.dart';
import 'package:news_app/search_page.dart';
import 'news.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
  List<String> tags = ['All', 'India', 'US', 'Nifty', 'Tesla'];

  // Index of the selected tag
  int selectedTagIndex = 0;
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
        title: const Text('NewsHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // print(_topNewsFuture);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage(themeMode: widget.themeMode,);
                  },
                ),
              );
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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Wrap(
            spacing: 15, // Space between tags
            runSpacing: 15, // Space between lines
            children: List.generate(tags.length, (index) {
              return ChoiceChip(
                label: Text(
                  tags[index],
                  style: TextStyle(
                    color:
                        selectedTagIndex == index ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                selected: selectedTagIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectedTagIndex = index; // Select one tag at a time
                  });
                },
                backgroundColor: widget.themeMode == ThemeMode.dark
                    ? (selectedTagIndex == index
                        ? Colors.pinkAccent
                        : Colors.grey[300])
                    : (selectedTagIndex == index
                        ? Colors.blueAccent
                        : Colors.grey[300]),
                selectedColor:
                    Colors.blueAccent, // Highlighted color for selection
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Stylish rounded shape
                ),
                elevation:
                    selectedTagIndex == index ? 8 : 4, // Elevation for the chip
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10), // Text padding
              );
            }),
          ),
          SizedBox(height: 10),
          Text("Top Headlines",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.themeMode == ThemeMode.dark
                    ? Colors.white70
                    : const Color.fromARGB(255, 51, 51, 51),
              )),
          FutureBuilder<List<dynamic>>(
            future: _topNewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final article = snapshot.data!;
              return listViewBuildForNews(article);
            },
          )
        ],
      ),
    );
  }

  Expanded listViewBuildForNews(List<dynamic> article) {
    return Expanded(
      child: ListView.builder(
        itemCount: article.length,
        itemBuilder: (context, index) {
          final news = article[index];
          final imageUrl = news['urlToImage'] ?? '';
          final title = news['title'] ?? 'No Title';
          final description = news['description'] ?? 'No Description Available';
          final publishedAt = news['publishedAt'] ?? '';
          final newsurl = news['url'];
          String formattedDate = '';
          if (publishedAt.isNotEmpty) {
            try {
              final dateTime = DateTime.parse(publishedAt);
              formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);
            } catch (e) {
              formattedDate = 'Invalid Date';
            }
          }
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: SizedBox(
                width: 100,
                height: 200,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Rounded corners for the image
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 400,
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
  }
}


// class Tinify{
//   final String apiKey = '';
//   final String apiUrl = 'https://api.tinify.com/shrink';
//   String compressedImageUrl = '';

//   Future<void> compressImage() async {
//     final response = await http.post(
//       Uri.parse('https://api.tinify.com/shrink'),
//       headers: {'Authorization': 'Basic $apiKey'},
//       body: {'source': url},
//     );
//   }
// }