import 'package:app_ta/core/models/word_cerf.dart';
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: ListView(
            shrinkWrap: true,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "CEFR LEVEL: ${appState.level.name.toUpperCase()}",
                  ),
                ),
              ),

              Row(
                children: [
                  Text("EXP: "),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: appState.getExpPercentage(),
                    ),
                  ),
                ],
              ),
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
              Column(
                children: [
                  Text("Random word range"),
                  SegmentedButton(
                    segments: [
                      for (var val in WordCerf.values)
                        if (val != WordCerf.unknown)
                          ButtonSegment(
                            value: val,
                            label: Text(val.name.toUpperCase()),
                          ),
                    ],
                    selected: appState.levelSelectionRange,
                    onSelectionChanged: (p0) async {
                      var set = p0.cast<WordCerf>();
                      setState(() {
                        appState.levelSelectionRange = set;
                      });
                      await appState.saveLevelSelectionRange();
                    },
                    multiSelectionEnabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
