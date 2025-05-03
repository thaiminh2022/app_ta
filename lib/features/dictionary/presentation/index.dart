import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/dictionary/presentation/world_info_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DictionarySearch extends StatefulWidget {
  DictionarySearch({super.key});

  @override
  State<DictionarySearch> createState() => _DictionarySearchState();
}

class _DictionarySearchState extends State<DictionarySearch> {
  final TextEditingController _controller = TextEditingController();

  void _performSearch(BuildContext context) async {
    if (_controller.text.isEmpty) return;
    await context.read<AppState>().addToSearchHistory(_controller.text);
    print("Added to history: ${_controller.text}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordInfoView(searchWord: _controller.text),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                hintText: "Write your word",
                label: Text("Search Word:"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _performSearch(context),
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
            // Add the "History:" label
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                "History:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Consumer<AppState>(
              builder: (context, appState, child) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: appState.searchHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(appState.searchHistory[index]),
                        onTap: () {
                          print("Tapped history item: ${appState.searchHistory[index]}");
                          setState(() {
                            _controller.text = appState.searchHistory[index];
                          });
                          print("Updated controller text to: ${_controller.text}");
                          _performSearch(context);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}