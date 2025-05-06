import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200, // Set a minimum width to make the card larger
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Streak',
                      style: TextStyle(
                        fontSize: 20, // Increase font size for title
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Streak: ${appState.streakDays} days',
                      style: TextStyle(
                        fontSize: 18, // Increase font size for streak text
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.local_fire_department, // Add a fire icon for visual balance
                  color: appState.streakDays > 0
                      ? Colors.orangeAccent // Active streak color
                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5), // Inactive streak color
                  size: 40, // Larger icon size
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}