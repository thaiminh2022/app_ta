import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/games/index.dart';
import 'package:flutter/material.dart';

class GameSpaceNavigator extends StatefulWidget {
  const GameSpaceNavigator({super.key});

  @override
  State<GameSpaceNavigator> createState() => _GameSpaceNavigatorState();
}

class _GameSpaceNavigatorState extends State<GameSpaceNavigator> {
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
            return GameSpace();
          },
        );
      },
    );
  }
}
