import 'dart:developer';

import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:flutter/material.dart';

class PhoneticDisplay extends StatelessWidget {
  const PhoneticDisplay({
    super.key,
    required this.text,
    required this.phonetic,
  });

  final String text;
  final WordPhonetic phonetic;

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
