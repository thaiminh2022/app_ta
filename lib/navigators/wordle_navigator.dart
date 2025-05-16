import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/games/wordle/presentation/index.dart';
import 'package:app_ta/features/games/wordle/presentation/wordle_game.dart';
import 'package:flutter/material.dart';

class WordleNavigator extends StatefulWidget {
  const WordleNavigator({super.key});

  @override
  State<WordleNavigator> createState() => _WordleNavigatorState();
}

class _WordleNavigatorState extends State<WordleNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) {
            if (settings.name == WordleGame.routeName) {
              final args = settings.arguments as WordleGameArgs;
              return WordleGame(wordInfo: args.wordInfo);
            }
            if (settings.name == WordInfoView.routeName) {
              final args = settings.arguments as WordInfoViewArgs;
              return WordInfoView(searchWord: args.searchWord, cerf: args.cerf);
            }
            return WordleView();
          },
        );
      },
    );
  }
}
