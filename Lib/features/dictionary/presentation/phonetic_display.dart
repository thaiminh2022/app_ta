import 'dart:developer';

import 'package:app_ta/core/models/word_info.dart';
import 'package:flutter/material.dart';

class PhoneticDisplay extends StatelessWidget {
  const PhoneticDisplay({super.key, required this.p});

  final Phonetic p;

  @override
  Widget build(BuildContext context) {
    if (p.text == null) return SizedBox.shrink();

    return Row(
      children: [
        IconButton(
          onPressed: () {
            log("user request audio");
          },
          icon: Icon(Icons.audiotrack),
        ),
        Text(p.text ?? "not happen"),
      ],
    );
  }
}
