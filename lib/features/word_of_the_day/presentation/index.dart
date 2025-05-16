import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day_model.dart';
import 'package:flutter/material.dart';
import 'package:app_ta/features/word_of_the_day/services/word_of_the_day_service.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class WordOfTheDayScreen extends StatelessWidget {
  WordOfTheDayScreen({super.key});
  final _wordService = WordOfTheDayService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: PageHeader("Daily Word"),
        actions: [ProfileMenu()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<Result<WordOfTheDayModel, String>>(
            future: _wordService.getWordOfTheDay(context.read<AppState>()),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final res = snapshot.requireData;
                if (res.isError) {
                  return Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Word of the day is not available"),
                            Text(res.unwrapError()),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return WordOfTheDay(word: res.unwrap());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Word of the day is not available"),
                          Text(snapshot.error.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class WordOfTheDay extends StatelessWidget {
  const WordOfTheDay({super.key, required this.word});

  final WordOfTheDayModel word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: const EdgeInsets.all(4), // Padding for the gradient border
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
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb, size: 100),
                Badge(
                  label: Text(word.cerf.name.toUpperCase()),
                  offset: Offset(20, 0),
                  child: Text(
                    word.word,
                    style: theme.primaryTextTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  word.definition ?? "",
                  textAlign: TextAlign.center,
                  style: theme.primaryTextTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 10),
                Visibility(
                  visible: word.definition != null,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        WordInfoView.routeName,
                        arguments: WordInfoViewArgs(word.word, cerf: word.cerf),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text("Check definition"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
