import 'dart:developer';

import 'package:flutter/material.dart';

class PhoneticDisplay extends StatelessWidget {
  const PhoneticDisplay({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            log("user request audio");
          },
          icon: Icon(Icons.audiotrack),
        ),
        Text(text),
      ],
    );
  }
}
