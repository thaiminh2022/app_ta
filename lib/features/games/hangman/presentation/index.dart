import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(173, 216, 230, 1),
                        Color.fromRGBO(135, 206, 235, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Hangman',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        shadows: [
                          Shadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.3),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
              ElevatedButton(
                onPressed: () async {
                  final wordRes =
                      await context.read<AppState>().getRandomWordCerf();

                  if (wordRes.isError) {
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
