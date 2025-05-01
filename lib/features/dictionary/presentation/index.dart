// the home page

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/world_info_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DictionarySearch extends StatelessWidget {
  DictionarySearch({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Dictionary"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Seach term",
                label: Text("search word"),
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
