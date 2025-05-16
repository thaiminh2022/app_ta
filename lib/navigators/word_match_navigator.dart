import 'package:flutter/material.dart';
import 'package:app_ta/features/games/word_match/presentation/index.dart';

class WordMatchNavigator extends StatefulWidget {
  const WordMatchNavigator({super.key});

  @override
  State<WordMatchNavigator> createState() => _WordMatchNavigatorState();
}

class _WordMatchNavigatorState extends State<WordMatchNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) {
            return const WordMatchScreen(word: '',);
          },
        );
      },
    );
  }
}