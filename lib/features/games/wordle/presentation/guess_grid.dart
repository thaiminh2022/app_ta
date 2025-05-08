import 'package:app_ta/features/games/wordle/presentation/widgets/guess_tile.dart';
import 'package:app_ta/features/games/wordle/services/game_state.dart';
import 'package:flutter/material.dart';

class GuessGrid extends StatelessWidget {
  const GuessGrid({super.key, required this.gameState});
  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> buildChildren() {
      var widgets = <Widget>[];
      var wordLength = gameState.targetWord.length;
      for (int i = 0; i < gameState.maxGuesses; i++) {
        // Submited
        if (i + 1 <= gameState.guesses.length) {
          int idx = 0;
          for (var c in gameState.guesses[i].characters) {
            c = c.toUpperCase();
            late final Color color;

            if (gameState.targetWord[idx] == c) {
              color = Colors.green;
            } else if (gameState.targetWord.contains(c)) {
              color = Colors.yellow;
            } else {
              color = Colors.red;
            }

            widgets.add(
              GuessTile(character: c, tileColor: color, wordLength: wordLength),
            );
            idx++;
          }
          // Not submited
        } else if (i == gameState.guesses.length) {
          for (int j = 0; j < wordLength; j++) {
            var char = ' ';
            if (j < gameState.currentGuess.length) {
              char = gameState.currentGuess[j];
            }

            widgets.add(
              GuessTile(
                character: char,
                tileColor: theme.colorScheme.primary,
                wordLength: wordLength,
              ),
            );
          }
          // Unrelated
        } else {
          for (var _ in gameState.targetWord.characters) {
            widgets.add(
              GuessTile(
                character: ' ',
                tileColor: theme.colorScheme.primary,
                wordLength: wordLength,
              ),
            );
          }
        }
      }
      return widgets;
    }

    return GridView.count(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      crossAxisCount: gameState.targetWord.length,
      children: buildChildren(),
    );
  }
}
