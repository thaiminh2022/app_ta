import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelingView extends StatefulWidget {
  const LevelingView({super.key});

  @override
  State<LevelingView> createState() => _LevelingViewState();
}

class _LevelingViewState extends State<LevelingView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final appState = context.read<AppState>();
      await appState.loadGamesCompleted();
      await appState.loadLearnedWords();
      appState.recalculateExp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: PageHeader("Level"),
        actions: [ProfileMenu()],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Level:"),
            Text(appState.level.name.toString()),
            Text("exp:"),
            Text(appState.exp.toString()),
            Row(
              children: [
                FilledButton(
                  onPressed: () async {
                    appState.addExp(10);
                    await appState.saveLevelData();
                  },

                  child: Text("add exp"),
                ),
                FilledButton(
                  onPressed: () async {
                    appState.resetLevel();
                    await appState.saveLevelData();
                  },

                  child: Text("reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
