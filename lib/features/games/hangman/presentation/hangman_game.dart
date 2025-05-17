import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/dictionary/presentation/word_info_view.dart';
import 'package:app_ta/features/games/hangman/models/hangman.dart';
import 'package:app_ta/features/games/hangman/presentation/widgets/hangman_hint.dart';
import 'package:app_ta/features/games/hangman/presentation/widgets/the_hangman_visual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';

class HangmanGameArgs {
  final String word;
  final WordCerf? cerf;

  HangmanGameArgs(this.word, {this.cerf});
}

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key, required this.word, this.cerf});
  final String word;
  final WordCerf? cerf;

  static const routeName = "/hangman_game";

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final TextEditingController _control = TextEditingController();
  late HangmanModel game;

  @override
  void initState() {
    super.initState();
    game = HangmanModel(widget.word);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildGameEnd(BuildContext dialogContext) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("The word was: ${game.word}"),
          SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              Navigator.maybePop(dialogContext);
              Navigator.pushNamed(
                context,
                WordInfoView.routeName,
                arguments: WordInfoViewArgs(game.word, cerf: widget.cerf),
              );
            },
            child: Text("Check definition"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.maybePop(context);
                },
                child: Text("Replay?"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text("Close"),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [ProfileMenu()],
      ),
      body: Container(
        margin: EdgeInsets.all(10),

        child: ListView(
          children: [
            Text("Wrong guesses: ${game.badGuesses.join("; ")}"),
            Center(
              child: Column(
                children: [
                  TheHangmanVisual(guessLeft: game.maxGuesses),
                  Text(game.getDisplay()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _control,
                    decoration: InputDecoration(
                      label: Text("Input a character / word"),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    game.guess(_control.text);
                    //set state here also update the visual of the game
                    setState(() {
                      _control.text = "";
                    });

                    if (game.isGameEnded) {
                      if (mounted && game.isWon) {
                        if (widget.cerf != null) {
                          Provider.of<AppState>(context, listen: false).addExpForGame(widget.cerf!);
                        } else {
                          Provider.of<AppState>(context, listen: false).addExp(2); // fallback
                        }
                        Provider.of<AppState>(context, listen: false).incrementGamesCompleted();
                      }
                      showDialog(
                        context: context,
                        builder:
                            (b) => AlertDialog.adaptive(
                              title: Text(game.isWon ? "You won" : "You lost"),
                              content: buildGameEnd(b),
                            ),
                      );
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Hints"),
            HangmanHint(word: widget.word),
          ],
        ),
      ),
    );
  }
}
