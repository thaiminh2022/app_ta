import 'dart:math';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/word_of_the_day/presentation/index.dart';
import 'package:flutter/material.dart';

class RandomButton extends StatelessWidget {
  final BuildContext context;

  const RandomButton({super.key, required this.context});

  void _navigateToRandomFeature() {
    final random = Random();
    final List<Widget> randomRoutes = [
      DictionarySearch(),
      Hangman(),
      WordOfTheDayScreen(),
    ];
    final randomRoute = randomRoutes[random.nextInt(randomRoutes.length)];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => randomRoute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: _navigateToRandomFeature,
        child: Container(
          width: 60, // Tăng từ 40 lên 60
          height: 60, // Tăng từ 40 lên 60
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(173, 216, 230, 1), // Light blue
                Color.fromRGBO(0, 120, 255, 1), // Dark blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Color.fromRGBO(255, 255, 255, 0.3),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.shuffle,
              color: Colors.white,
              size: 30, // Tăng từ 20 lên 30
            ),
          ),
        ),
      ),
    );
  }
}