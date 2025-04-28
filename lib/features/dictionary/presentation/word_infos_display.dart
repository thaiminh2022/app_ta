import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meaning_display.dart';
import 'phonetic_display.dart';

class WordInfosDisplay extends StatelessWidget {
  const WordInfosDisplay({super.key, required this.wordInfos});

  final List<WordInfo> wordInfos;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ListView(
      children: [
        for (var w in wordInfos)
          WordInfoDisplay(wordInfo: w, appState: appState),
      ],
    );
  }
}

class WordInfoDisplay extends StatelessWidget {
  const WordInfoDisplay({
    super.key,
    required this.wordInfo,
    required this.appState,
  });

  final WordInfo wordInfo;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );
    var learnedWords = appState.learnedWords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${wordInfo.word} - ${wordInfo.license.name}",
                style: textStyle,
              ),
            ),
            IconButton(
              onPressed: () {
                if (!learnedWords.contains(wordInfo.word)) {
                  appState.addWordToLearned(wordInfo.word);
                } else {
                  appState.removeWordFromLearned(wordInfo.word);
                }
              },
              icon: Icon(
                learnedWords.contains(wordInfo.word)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
            ),
          ],
        ),
        // Phonetics
        for (var p in wordInfo.phonetics) PhoneticDisplay(p: p),
        Divider(),
        for (var m in wordInfo.meanings) MeaningDisplay(m: m),
      ],
    );
  }
}
