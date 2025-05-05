import 'package:flutter/material.dart';
import 'package:app_ta/features/word_of_the_day/models/word_of_the_day.dart';
import 'package:app_ta/features/word_of_the_day/services/word_of_the_day_service.dart';
import 'package:app_ta/features/word_of_the_day/presentation/notification_setting_screen.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class WordOfTheDayScreen extends StatelessWidget {
  WordOfTheDayScreen({super.key});
  final _wordService = WordOfTheDayService();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

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
      body: FutureBuilder<WordOfTheDay?>(
        future: _wordService.getWordOfTheDay(appState),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final word = snapshot.data;
          if (word == null) {
            return const Center(child: Text("No word available today."));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  word.ipa,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Meaning:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(word.meaning, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text(
                  'Example:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  word.example,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
