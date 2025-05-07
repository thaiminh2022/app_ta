import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:app_ta/features/dictionary/presentation/widget/learned_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meaning_display.dart';
import 'phonetic_display.dart';

class WordInfosDisplay extends StatelessWidget {
  const WordInfosDisplay({super.key, required this.wordInfo, this.cerf});

  final WordInfoUsable wordInfo;
  final WordCerf? cerf;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ListView(
      children: [WordInfoDisplay(wordInfo: wordInfo, appState: appState)],
    );
  }
}

class WordInfoDisplay extends StatelessWidget {
  const WordInfoDisplay({
    super.key,
    required this.wordInfo,
    required this.appState,
    this.cerf,
  });

  final WordInfoUsable wordInfo;
  final AppState appState;
  final WordCerf? cerf;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    Widget buildCerf() {
      if (cerf == null) {
        return FutureBuilder(
          future: appState.getWordCerf(wordInfo.word),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var cerf = snapshot.requireData;

              return Text(cerf.name.toUpperCase());
            }
            return SizedBox.shrink();
          },
        );
      }

      return Text(cerf!.name.toUpperCase());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    offset: Offset(10, -5),
                    label: buildCerf(),
                    child: Text(wordInfo.word, style: textStyle),
                  ),
                ],
              ),
            ),
            LearnedButton(word: wordInfo.word),
          ],
        ),
        // Phonetics
        for (var p in wordInfo.phonetics.entries)
          PhoneticDisplay(text: p.key, phonetic: p.value),
        Divider(),
        for (var m in wordInfo.meanings.entries)
          MeaningDisplay(partOfSpeech: m.key, definitions: m.value),
      ],
    );
  }
}
