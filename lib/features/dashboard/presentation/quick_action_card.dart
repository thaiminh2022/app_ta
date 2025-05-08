import 'package:app_ta/features/dashboard/presentation/widgets/menu_action_button.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/games/wordle/game_screen.dart';
import 'package:app_ta/features/word_of_the_day/presentation/index.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Container(
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
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80,
                    child: MenuActionButton(
                      icon: Icons.book,
                      label: 'Dictionary',
                      route: DictionarySearch(),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: MenuActionButton(
                      icon: Icons.gamepad,
                      label: 'Hangman',
                      route: Hangman(),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: MenuActionButton(
                      icon: Icons.lightbulb_outline,
                      label: 'Daily Word',
                      route: WordOfTheDayScreen(),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: MenuActionButton(
                      icon: Icons.grid_on,
                      label: 'Wordle',
                      route: const GameScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}