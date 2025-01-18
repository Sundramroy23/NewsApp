import 'package:flutter/material.dart';
import 'news.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedSearch = '';
  List<dynamic> apiResults = [];
  bool isLoading = false;
  List<String> suggestedItems = [
    "Saif Ali Khan",
    "Israel",
    "HMVP",
    "Bharatiya Janata Party (BJP)",
    "Election Results 2024",
    "Copa América",
    "U.S. Election",
    "Olympic Games"
  ];

  Future<void> fetchResults(String query) async {
    setState(() {
      isLoading = true;
      apiResults = [];
    });

    try {
      final response = await NewsService().getSearchNews(query);
      setState(() {
        selectedSearch = query;
        apiResults = response;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching news articles')),
      );
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              // constraints: BoxConstraints(maxWidth: 500, minWidth: 100),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  focusColor: const Color.fromARGB(255, 96, 96, 97),
                  hoverColor: const Color.fromARGB(255, 96, 96, 97),
                  fillColor: const Color.fromARGB(255, 96, 96, 97),

                  hintText: 'Search',
                  // hintFadeDuration: Duration(seconds: 0.2),
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (query) => print(query),
              ),
            ),
            Expanded(
              // margin: EdgeInsets.all(10),
              child: SearchSuggestion(suggestedItems: suggestedItems),
            )
          ],
        ),
      ),
    );
  }
}

class SearchSuggestion extends StatelessWidget {
  late List<String> suggestedItems = [];
  SearchSuggestion({
    super.key,
    required this.suggestedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Top Searches'),
        Expanded(
          child: ListView.separated(
            itemCount: suggestedItems.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
              thickness: 0.1,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {print("Article $index clicked")},
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: const Color.fromARGB(255, 91, 90, 90),
                      ),
                      SizedBox(width: 10),
                      Text(
                        suggestedItems[index],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchItmes extends StatelessWidget {
  const SearchItmes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
