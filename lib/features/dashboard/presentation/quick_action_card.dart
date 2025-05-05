import 'package:app_ta/features/dashboard/presentation/widgets/menu_action_button.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                MenuActionButton(icon: Icons.book, label: 'Dictionary'),
                MenuActionButton(icon: Icons.gamepad, label: 'Hangman'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
