import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day_model.dart';
import 'package:flutter/material.dart';
import 'package:app_ta/features/word_of_the_day/services/word_of_the_day_service.dart';
import 'package:app_ta/features/word_of_the_day/presentation/notification_setting_screen.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class WordOfTheDayScreen extends StatelessWidget {
  WordOfTheDayScreen({super.key});
  final _wordService = WordOfTheDayService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word of the Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<WordOfTheDayModel>(
          future: _wordService.getWordOfTheDay(context.read<AppState>()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final word = snapshot.requireData;
            return WordOfTheDay(word: word);
          },
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => WordInfoView(searchWord: word.word),
                    ),
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
    );
  }
}
