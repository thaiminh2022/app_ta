import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/games/hangman/presentation/hangman_game.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:flutter/material.dart';

class HangmanNavigator extends StatefulWidget {
  const HangmanNavigator({super.key});

  @override
  State<HangmanNavigator> createState() => _HangmanNavigatorState();
}

class _HangmanNavigatorState extends State<HangmanNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) {
            if (settings.name == HangmanGame.routeName) {
              final args = settings.arguments as HangmanGameArgs;
              return HangmanGame(word: args.word, cerf: args.cerf);
            }
            if (settings.name == WordInfoView.routeName) {
              final args = settings.arguments as WordInfoViewArgs;
              return WordInfoView(searchWord: args.searchWord, cerf: args.cerf);
            }
            return Hangman();
          },
        );
      },
    );
  }
}
