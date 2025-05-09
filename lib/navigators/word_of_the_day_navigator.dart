import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/word_of_the_day/presentation/index.dart';
import 'package:flutter/material.dart';

class WordOfTheDayNavigator extends StatefulWidget {
  const WordOfTheDayNavigator({super.key});

  @override
  State<WordOfTheDayNavigator> createState() => _WordOfTheDayNavigatorState();
}

class _WordOfTheDayNavigatorState extends State<WordOfTheDayNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            if (settings.name == WordInfoView.routeName) {
              final args = settings.arguments as WordInfoViewArgs;
              return WordInfoView(searchWord: args.searchWord, cerf: args.cerf);
            }
            return WordOfTheDayScreen();
          },
        );
      },
    );
  }
}
