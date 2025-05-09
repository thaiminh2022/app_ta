// the home page

import 'package:app_ta/features/dictionary/presentation/learned_words_view.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/dictionary/services/search_history_service.dart';
import 'package:flutter/material.dart';

class DictionarySearch extends StatelessWidget {
  DictionarySearch({super.key});

  final SearchController _controller = SearchController();
  final SearchHistoryService searchHistoryService = SearchHistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(173, 216, 230, 1),
                        Color.fromRGBO(135, 206, 235, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Dictionary',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        shadows: [
                          Shadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.3),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books,
                size: 150,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    DictionarySearchBarView(
                      controller: _controller,
                      historyService: searchHistoryService,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_controller.text.isEmpty) return;

                              await searchHistoryService.saveItem(
                                _controller.text,
                              );
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => WordInfoView(
                                          searchWord:
                                              _controller.text.toLowerCase(),
                                        ),
                                  ),
                                );
                              }
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
                              MaterialPageRoute(
                                builder: (ctx) => LearnedWordsView(),
                              ),
                            );
                          },
                          child: Text("Learned words"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DictionarySearchBarView extends StatelessWidget {
  const DictionarySearchBarView({
    super.key,
    required this.controller,
    required this.historyService,
  });

  final SearchController controller;
  final SearchHistoryService historyService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SearchAnchor(
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
                          child: FutureBuilder(
                            future: historyService.searchHistory,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                var data = snapshot.requireData;
                                return SearchHistoryItemView(
                                  data: data,
                                  historyService: historyService,
                                );
                              }
                              if (snapshot.hasError) {
                                return SizedBox.shrink();
                              } else {
                                return LoadingCircle();
                              }
                            },
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
      ),
    );
  }
}

class SearchHistoryItemView extends StatefulWidget {
  const SearchHistoryItemView({
    super.key,
    required this.data,
    required this.historyService,
  });

  final Set<String> data;
  final SearchHistoryService historyService;

  @override
  State<SearchHistoryItemView> createState() => _SearchHistoryItemViewState();
}

class _SearchHistoryItemViewState extends State<SearchHistoryItemView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
          widget.data
              .map(
                (s) => ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(s)),
                      IconButton(
                        onPressed: () {
                          widget.historyService.removeItem(s);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WordInfoView(searchWord: s),
                      ),
                    );
                  },
                ),
              )
              .toList(),
    );
  }
}
