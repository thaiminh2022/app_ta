import 'package:flutter/material.dart';

class MenuActionButton extends StatelessWidget {
  const MenuActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final Widget route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => route));
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
