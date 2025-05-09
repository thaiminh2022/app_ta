import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/dictionary/presentation/learned_words_view.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:flutter/material.dart';

class DictionaryNavigator extends StatefulWidget {
  const DictionaryNavigator({super.key});

  @override
  State<DictionaryNavigator> createState() => _DictionaryNavigatorState();
}

class _DictionaryNavigatorState extends State<DictionaryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) {
            if (settings.name == WordInfoView.routeName) {
              final args = settings.arguments as WordInfoViewArgs;
              return WordInfoView(searchWord: args.searchWord, cerf: args.cerf);
            }
            if (settings.name == LearnedWordsView.routeName) {
              return LearnedWordsView();
            }
            return DictionarySearch();
          },
        );
      },
    );
  }
}
