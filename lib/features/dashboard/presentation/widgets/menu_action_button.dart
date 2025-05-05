import 'package:flutter/material.dart';

class MenuActionButton extends StatelessWidget {
  const MenuActionButton({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (label == 'Dictionary') {
          Navigator.pushNamed(context, '/dictionary');
        } else if (label == 'Hangman') {
          Navigator.pushNamed(context, '/hangman');
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
