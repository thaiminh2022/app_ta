import 'package:flutter/material.dart';

class GuessTile extends StatelessWidget {
  const GuessTile({
    super.key,
    required this.character,
    required this.tileColor,
    required this.wordLength,
  });
  final String character;
  final Color tileColor;
  final int wordLength;

  @override
  Widget build(BuildContext context) {
    // Giới hạn kích thước dựa trên cả chiều rộng và chiều cao
    final maxTileSize = 50.0;

    return Container(
      color: tileColor,
      width: maxTileSize,
      constraints: BoxConstraints(
        maxWidth: maxTileSize,
        maxHeight: maxTileSize,
      ),
      height: maxTileSize,
      child: Center(
        child: Text(
          character,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
