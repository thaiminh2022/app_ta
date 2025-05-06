import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnedButton extends StatelessWidget {
  const LearnedButton({
    super.key,
    required this.word,
    this.onDelete,
    this.onAdded,
  });

  final String word;
  final Function(String deletedWord)? onDelete;
  final Function(String addedWord)? onAdded;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var learnedWords = appState.learnedWords;
    return IconButton(
      onPressed: () {
        if (!learnedWords.contains(word)) {
          appState.addWordToLearned(word);
          onAdded?.call(word);
        } else {
          appState.removeWordFromLearned(word);
          onDelete?.call(word);
        }
      },
      icon: Icon(
        learnedWords.contains(word)
            ? Icons.favorite_rounded
            : Icons.favorite_border,
        color: learnedWords.contains(word) ? Colors.pink : null,
      ),
    );
  }
}
