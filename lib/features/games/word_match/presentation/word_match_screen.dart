import 'package:app_ta/core/services/word_info_cleanup_service.dart';
import 'package:flutter/material.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';

class WordMatchScreen extends StatefulWidget {
  final WordInfoUsable wordInfo;

  const WordMatchScreen({super.key, required this.wordInfo});

  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen> {
  Set<String> synonyms = {};
  Set<String> antonyms = {};

  @override
  void initState() {
    super.initState();
    synonyms = widget.wordInfo.synonyms;
    antonyms = widget.wordInfo.antonyms;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [ProfileMenu()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            padding: const EdgeInsets.all(4), // Padding for the gradient border
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
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lightbulb, size: 100),
                  Text(
                    "Word: ${widget.wordInfo.word}",
                    style: theme.primaryTextTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Column(
                    children: [
                      Text(
                        "Synonyms: ${synonyms.isNotEmpty ? synonyms.join(", ") : "None found"}",
                        textAlign: TextAlign.center,
                        style: theme.primaryTextTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Antonyms: ${antonyms.isNotEmpty ? antonyms.join(", ") : "None found"}",
                        textAlign: TextAlign.center,
                        style: theme.primaryTextTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
