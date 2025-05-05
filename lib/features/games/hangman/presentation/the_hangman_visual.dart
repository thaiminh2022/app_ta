import 'package:flutter/material.dart';

final bodyParts = <String>[
  "assets/hangman/hang.png",
  "assets/hangman/head.png",
  "assets/hangman/body.png",
  "assets/hangman/la.png",
  "assets/hangman/ra.png",
  "assets/hangman/ll.png",
  "assets/hangman/rl.png",
];

class TheHangmanVisual extends StatelessWidget {
  const TheHangmanVisual({super.key, required this.guessLeft});
  final int guessLeft;

  List<Widget> buildVisual() {
    List<Widget> widgets = [];

    for (int i = 0; i < bodyParts.length; i++) {
      widgets.add(
        AnimatedSize(
          duration: Durations.medium1,
          curve: Curves.easeOut,
          child: Visibility(
            visible: guessLeft < bodyParts.length - i,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(bodyParts[i], color: Colors.black),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [...buildVisual()]);
  }
}
