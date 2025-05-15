import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/games/wordle/presentation/guess_grid.dart';
import 'package:app_ta/features/games/wordle/presentation/hint_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import 'result_dialog.dart';

class WordleGame extends StatefulWidget {
  const WordleGame({super.key});

  @override
  WordleGameState createState() => WordleGameState();
}

class WordleGameState extends State<WordleGame> {
  late GameState gameState;
  final _submitController = TextEditingController();
  bool _isLoading = false;

  Future<void> startNewGame() async {
    _isLoading = true;
    final wordRes = await context.read<AppState>().getRandomWordCerf();

    setState(() {
      gameState = GameState(
        targetWord: wordRes.word.toUpperCase(),
        maxGuesses: wordRes.word.length >= 7 ? 8 : 6,
      );
    });
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    startNewGame();
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        hasWon: gameState.hasWon(),
        targetWord: gameState.targetWord,
        onPlayAgain: () {
          Navigator.pop(context);
          startNewGame();
        },
        onExit: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      'Wordle',
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
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lưới đoán từ
            Expanded(
              child: Center(child: GuessGrid(gameState: gameState)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: const EdgeInsets.all(4), // Padding for the gradient border
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
                    decoration: InputDecoration(
                      label: Text("Guess a word"),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z]+$'),
                      ),
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
                FilledButton(
                  onPressed: onSubmited,
                  child: Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}