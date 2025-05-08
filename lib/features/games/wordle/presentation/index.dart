import 'dart:developer';
import 'dart:math';

import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import '../services/wordle_service.dart';
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
      if (gameState.hasWon() || gameState.hasLost()) {
        showResultDialog();
      }
    }
    _submitController.text = ' ';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
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
                      'WORDLE',
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
      body:
          _isLoading
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HintBtn(targetWord: gameState.targetWord),
                        FilledButton(
                          onPressed: onSubmited,
                          child: Text("submit"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}

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

class GuessTile extends StatelessWidget {
  const GuessTile({
    super.key,
    required this.character,
    required this.tileColor,
    required this.wordLength,
  });
  final String character;
  final Color tileColor;
  final int wordLength;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Giới hạn kích thước dựa trên cả chiều rộng và chiều cao
    final maxTileSize = 50.0;

    return Container(
      color: tileColor,
      width: maxTileSize,
      constraints: BoxConstraints(
        maxWidth: maxTileSize,
        maxHeight: maxTileSize,
      ),
      height: maxTileSize,
      child: Center(
        child: Text(
          character,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class HintBtn extends StatelessWidget {
  HintBtn({super.key, required this.targetWord});

  final String targetWord;
  final _apiService = WordleService();

  Future<void> showHint(BuildContext context) async {
    // Check if the widget is still mounted before proceeding

    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Hint'),
              content: FutureBuilder(
                future: _apiService.fetchWordDefinition(targetWord),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.requireData.isEmpty
                          ? "No definition"
                          : snapshot.requireData,
                    );
                  } else if (snapshot.hasError) {
                    return Text("internal error");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          showHint(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        child: const Text('Hint'),
      ),
    );
  }
}
