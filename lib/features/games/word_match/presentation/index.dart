import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/word_match/presentation/word_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'word_match_screen.dart';

class WordMatch extends StatelessWidget {
  const WordMatch({super.key});
  static const routeName = "/word-match";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const PageHeader("Word Match"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [ProfileMenu()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () async {
                  var appState = context.read<AppState>();
                  var learnedWords = appState.learnedWords;
                  if (learnedWords.isEmpty) return;

                  var randIdx = Random().nextInt(learnedWords.length);
                  var randWord = learnedWords[randIdx];
                  var wordInfoRes = await appState.searchWord(randWord);

                  if (wordInfoRes.isError) {
                    return;
                  }

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                WordMatchScreen(wordInfo: wordInfoRes.unwrap()),
                      ),
                    );
                  }
                },
                child: const Text("From learned words"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var randRes =
                      await context.read<AppState>().getRandomWordCerf();

                  if (randRes.isError) {
                    print(randRes.error);
                    return;
                  }

                  final randWord = randRes.unwrap();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                WordMatchScreen(wordInfo: randWord.wordInfo),
                      ),
                    );
                  }
                },
                child: const Text("From a random word"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
