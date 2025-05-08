import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final bool hasWon;
  final String targetWord;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const ResultDialog({
    super.key,
    required this.hasWon,
    required this.targetWord,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(hasWon ? 'Congratulations!' : 'Game Over'),
      content: Text(
        hasWon
            ? 'You guessed the word "$targetWord" correctly!'
            : 'The word was "$targetWord". Better luck next time!',
      ),
      actions: [
        TextButton(
          onPressed: onPlayAgain,
          child: const Text('Play Again'),
        ),
        TextButton(
          onPressed: onExit,
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
