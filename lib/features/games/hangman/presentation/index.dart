import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/utils/error_calls.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/hangman/presentation/hangman_game.dart';
import 'package:app_ta/features/games/hangman/presentation/widgets/the_hangman_visual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hangman extends StatelessWidget {
  const Hangman({super.key});
  static const routeName = "/hangman";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: PageHeader("Hangman"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [ProfileMenu()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TheHangmanVisual(guessLeft: 0),
              FilledButton(
                onPressed: () {
                  var learnedWord = context.read<AppState>().learnedWords;
                  if (learnedWord.isEmpty) {
                    showSnackError(context, "You haven't learn any words");
                    return;
                  }

                  var randIdx = Random().nextInt(learnedWord.length);
                  var randWord = learnedWord[randIdx];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HangmanGame(word: randWord),
                    ),
                  );
                },
                child: Text("From learned words"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final wordRes =
                      await context.read<AppState>().getRandomWordCerf();

                  if (wordRes.isError) {
                    if (context.mounted) {
                      showSnackError(context, wordRes.unwrapError());
                    }

                    return;
                  }
                  final wordData = wordRes.unwrap();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => HangmanGame(
                              word: wordData.wordInfo.word,
                              cerf: wordData.cerf,
                            ),
                      ),
                    );
                  }
                },
                child: Text("From a random words"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
