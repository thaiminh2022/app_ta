import 'package:flutter/material.dart';
import 'package:app_ta/features/pronunciation_checker/pronunciation_checker.dart';

class PronunciationCheckerPage extends StatelessWidget {
  const PronunciationCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Checker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Practice your pronunciation by speaking the target word.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const PronunciationChecker(),
            ),
          ),
        ],
      ),
    );
  }
}