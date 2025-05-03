import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/features/dictionary/presentation/world_info_view.dart';
import 'package:app_ta/features/games/hangman/models/hangman.dart';
import 'package:flutter/material.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key, required this.word, this.cerf});
  final String word;
  final WordCerf? cerf;

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
    List<Widget> buildGameUpdate() {
      if (!game.isGameEnded) {
        return [];
      }
      String message = game.isWon ? "You won" : "You lost";
      return [
        Center(
          child: Column(
            children: [
              Text(message),
              Text("The word was: ${game.word}"),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WordInfoView(
                            searchWord: game.word,
                            cerf: widget.cerf,
                          ),
                    ),
                  );
                },
                child: Text("Check word definition"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Replay?"),
              ),
            ],
          ),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(title: Text("hangman game")),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Guesses left: ${game.maxGuesses}"),
            Text(game.getDisplay()),
            TextField(
              controller: _control,
              decoration: InputDecoration(
                label: Text("Input a character/guess word"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                game.guess(_control.text);
                //set state here also update the visual of the game
                setState(() {
                  _control.text = "";
                });
              },
              child: Text("guess"),
            ),
            Text("Wrong: ${game.badGuesses.join(" ")}"),
            ...buildGameUpdate(),
          ],
        ),
      ),
    );
  }
}
