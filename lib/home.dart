import 'package:flutter/material.dart';
import 'package:google_clone/services/search_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<dynamic> _results = [];

  _search() async {
    if (_searchController.text.isEmpty) return;

    final results = await _searchService.search(_searchController.text);
    setState(() {
      _results = results;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Image.asset(
            'assets/google_logo.png',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Google",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          const SizedBox(height: 10),
          if (_results.isEmpty)
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.orange),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.language, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.school, color: Colors.green),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.music_note, color: Colors.red),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _results.isEmpty ? 1 : _results.length,
                itemBuilder: (context, index) {
                  if (_results.isNotEmpty) {
                    final item = _results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          item['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(item['snippet']),
                        onTap: () {
                          final url = item['link'];
                          if (url != null && url.isNotEmpty) {
                            _launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid URL')),
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('No results to show'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
