import 'package:flutter/material.dart';
import 'dart:math';
import '../services/game_state.dart';
import '../services/wordle_service.dart';
import 'keyboard.dart';
import 'guess_tile.dart';
import 'result_dialog.dart';

class WordleGame extends StatefulWidget {
  const WordleGame({super.key});

  @override
  WordleGameState createState() => WordleGameState();
}

class WordleGameState extends State<WordleGame> {
  late GameState gameState;
  final WordleService apiService = WordleService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  Future<void> startNewGame() async {
    setState(() => isLoading = true);
    final random = Random();

    final probability = random.nextDouble();
    int randomLength;

    if (probability < 0.7) {
      randomLength = 3 + random.nextInt(3); // 3–5
    } else if (probability < 0.9) {
      randomLength = 6 + random.nextInt(3); // 6–8
    } else {
      randomLength = 9 + random.nextInt(2); // 9–10
    }

    final word = await apiService.fetchRandomWord(randomLength);
    setState(() {
      gameState = GameState(
        targetWord: word.toUpperCase(),
        maxGuesses: word.length >= 7 ? 8 : 6,
      );
      isLoading = false;
    });
  }

  void handleKeyPress(String key) {
    setState(() {
      if (key == 'ENTER') {
        if (gameState.canSubmitGuess()) {
          gameState.submitGuess();
          if (gameState.hasWon() || gameState.hasLost()) {
            showResultDialog();
          }
        }
      } else if (key == 'BACK') {
        gameState.deleteLastLetter();
      } else {
        gameState.addLetter(key);
      }
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ResultDialog(
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

  Future<void> showHint() async {
    final definition = await apiService.fetchWordDefinition(
      gameState.targetWord,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hint'),
            content: Text(
              definition.isNotEmpty ? definition : 'No definition found.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(title: const Text('WORDLE'), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final totalHeight = constraints.maxHeight;
                  final keyboardHeight = 180.0;
                  final hintHeight = 50.0;
                  final guessAreaHeight =
                      totalHeight - keyboardHeight - hintHeight;

                  return Column(
                    children: [
                      // Lưới đoán từ
                      SizedBox(
                        height: guessAreaHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(gameState.maxGuesses, (i) {
                            return GuessRow(
                              guess:
                                  i < gameState.guesses.length
                                      ? gameState.guesses[i]
                                      : (i == gameState.guesses.length
                                          ? gameState.currentGuess
                                          : ''),
                              targetWord: gameState.targetWord,
                              isSubmitted: i < gameState.guesses.length,
                              wordLength: gameState.targetWord.length,
                            );
                          }),
                        ),
                      ),

                      // Nút Hint
                      SizedBox(
                        height: hintHeight,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: showHint,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Hint'),
                          ),
                        ),
                      ),

                      // Bàn phím
                      SizedBox(
                        height: keyboardHeight,
                        child: VirtualKeyboard(
                          onKeyPress: handleKeyPress,
                          usedLetters: gameState.getUsedLetters(),
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}
