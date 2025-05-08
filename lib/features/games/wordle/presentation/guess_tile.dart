import 'package:flutter/material.dart';
import 'dart:math';

class GuessRow extends StatelessWidget {
  final String guess;
  final String targetWord;
  final bool isSubmitted;

  const GuessRow({
    super.key,
    required this.guess,
    required this.targetWord,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final wordLength = targetWord.length;

    // Giới hạn kích thước dựa trên cả chiều rộng và chiều cao
    final maxTileSize = min(screenWidth / (wordLength + 2), screenHeight / 16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(wordLength, (index) {
          String letter = index < guess.length ? guess[index] : '';
          Color bgColor = Colors.white;
          Color borderColor = Colors.black;

          if (isSubmitted && letter.isNotEmpty) {
            if (letter == targetWord[index]) {
              bgColor = Colors.green;
            } else if (targetWord.contains(letter)) {
              bgColor = Colors.yellow;
            } else {
              bgColor = Colors.grey;
            }
          }

          return Container(
            width: maxTileSize,
            height: maxTileSize,
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: maxTileSize * 0.6,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
