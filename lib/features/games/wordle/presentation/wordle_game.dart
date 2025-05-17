import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/games/wordle/presentation/widgets/guess_grid.dart';
import 'package:app_ta/features/games/wordle/presentation/widgets/hint_btn.dart';
import 'package:app_ta/features/games/wordle/services/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';

class WordleGameArgs {
  WordInfoUsable wordInfo;

  WordleGameArgs({required this.wordInfo});
}

class WordleGame extends StatefulWidget {
  const WordleGame({super.key, required this.wordInfo});
  final WordInfoUsable wordInfo;
  static const routeName = "/wordle_game";

  @override
  WordleGameState createState() => WordleGameState();
}

class WordleGameState extends State<WordleGame> {
  late GameState gameState;
  final _submitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      gameState = GameState(
        targetWord: widget.wordInfo.word.toUpperCase(),
        maxGuesses: widget.wordInfo.word.length >= 7 ? 8 : 6,
      );
    });
  }

  void onInputChanged(String newInput) {
    setState(() {
      if (newInput.length <= gameState.targetWord.length) {
        gameState.currentGuess = newInput;
      }
    });
  }

  void onSubmited() {
    if (gameState.canSubmitGuess()) {
      gameState.submitGuess();
      setState(() {});
    }
    if (gameState.hasWon() || gameState.hasLost()) {
      showResultDialog();
    }
    _submitController.text = ' ';
  }

  void showResultDialog() {
    // Add 2 exp for finishing a game
    Provider.of<AppState>(context, listen: false).addExp(2);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogCtx) => AlertDialog(
            title: Text(gameState.hasWon() ? 'Congratulations!' : 'Game Over'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gameState.hasWon()
                      ? 'You guessed the word "${gameState.targetWord}" correctly!'
                      : 'The word was "${gameState.targetWord}". Better luck next time!',
                ),
                SizedBox(height: 10),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    Navigator.pushNamed(
                      context,
                      WordInfoView.routeName,
                      arguments: WordInfoViewArgs(gameState.targetWord),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Text("Check definition"),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.maybePop(dialogCtx);
                  Navigator.pop(context);
                },
                child: const Text('Play Again'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: PageHeader("Wordle"),
        actions: [ProfileMenu()],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lưới đoán từ
            Expanded(child: Center(child: GuessGrid(gameState: gameState))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: const EdgeInsets.all(
                  4,
                ), // Padding for the gradient border
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
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _submitController,
                    onChanged: onInputChanged,
                    decoration: InputDecoration(label: Text("Guess a word")),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')),
                    ],
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: (_) => onSubmited(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HintBtn(targetWord: gameState.targetWord),
                FilledButton(onPressed: onSubmited, child: Text("Submit")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
