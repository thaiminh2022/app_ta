// the home page

import 'package:app_ta/features/dictionary/presentation/learned_words_view.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:flutter/material.dart';

class DictionarySearch extends StatelessWidget {
  DictionarySearch({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dictionary")),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_books, size: 150),
              SizedBox(height: 20),
              TextField(
                controller: _controller,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Seach term",
                  label: Text("search word"),
                ),
              ),
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
      ),
    );
  }
}
