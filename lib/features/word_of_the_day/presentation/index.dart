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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home_screen/dashboard.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
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
                        'Word of the Day',
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
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
      ),
    );
  }
}