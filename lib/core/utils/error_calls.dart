import 'package:flutter/material.dart';

void showSnackError(BuildContext ctx, String msg) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(ctx).colorScheme.errorContainer,
      content: Text(
        msg,
        style: TextStyle(
          color: Theme.of(ctx).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
