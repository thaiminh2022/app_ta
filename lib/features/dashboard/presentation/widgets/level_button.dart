import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/leveling/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckLevelButton extends StatelessWidget {
  const CheckLevelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return FilledButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => LevelingView()),
        );
      },
      child: Row(
        children: [Text("CEFR LEVEL: ${appState.level.name.toUpperCase()}")],
      ),
    );
  }
}
