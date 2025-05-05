import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/games/hangman/presentation/hangman_game.dart';
import 'package:app_ta/features/games/hangman/presentation/the_hangman_visual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hangman extends StatelessWidget {
  const Hangman({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Icon(Icons.gamepad), SizedBox(width: 10), Text("Hangman")],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "THE HANGMAN GAME",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize:
                    Theme.of(context).primaryTextTheme.displaySmall?.fontSize,
              ),
            ),
            TheHangmanVisual(guessLeft: 0),
            FilledButton(
              onPressed: () {
                var learnedWord = context.read<AppState>().learnedWords;
                if (learnedWord.isEmpty) return;

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
            OutlinedButton(
              onPressed: () async {
                var wordRes =
                    await context.read<AppState>().getRandomWordCerf();
                Navigator.push(
                  // handle this later
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            HangmanGame(word: wordRes.word, cerf: wordRes.cerf),
                  ),
                );
              },
              child: Text("From a random words"),
            ),
          ],
        ),
      ),
    );
  }
}
