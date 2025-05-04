// the home page

import 'package:app_ta/features/dictionary/presentation/learned_words_view.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:flutter/material.dart';

class DictionarySearch extends StatelessWidget {
  DictionarySearch({super.key});

  final SearchController _controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dictionary")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 150),
            SizedBox(height: 10),
            DictionarySearchBarView(controller: _controller),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_controller.text.isEmpty) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  WordInfoView(searchWord: _controller.text),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10),
                        Text("Search"),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => LearnedWordsView()),
                    );
                  },
                  child: Text("Learned words"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DictionarySearchBarView extends StatelessWidget {
  const DictionarySearchBarView({super.key, required this.controller});

  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      suggestionsBuilder: (context, controller) {
        return [];
      },
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          hintText: "hello",
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16),
          ),

          leading: Icon(Icons.search),
          trailing: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: [
                            Text("cool whip"),
                            Text("cool whip"),
                            Text("cool whip"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.history),
            ),
          ],
        );
      },
    );
  }
}
