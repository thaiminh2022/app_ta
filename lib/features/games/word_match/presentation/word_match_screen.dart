import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/word_match/services/ai_word_match_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordMatchScreen extends StatefulWidget {
  final WordMatchData initialMatch;
  final bool isSynonymMode;
  final VoidCallback onRefresh;
  final VoidCallback onToggleMode;

  const WordMatchScreen({
    super.key,
    required this.initialMatch,
    required this.isSynonymMode,
    required this.onRefresh,
    required this.onToggleMode,
  });

  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen> {
  late WordMatchData _currentMatch;
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _currentMatch = widget.initialMatch;
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
    });

    if (answer == _currentMatch.correctAnswer) {
      context.read<AppState>().addWordToLearned(_currentMatch.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildBody() {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                  child: Text(
                    _currentMatch.word.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _currentMatch.answerOptions.map((option) {
                return ElevatedButton(
                  onPressed: _showResult ? null : () => _selectAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showResult
                        ? option == _currentMatch.correctAnswer
                        ? Colors.green
                        : _selectedAnswer == option
                        ? Colors.red
                        : null
                        : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (_showResult)
              Text(
                _selectedAnswer == _currentMatch.correctAnswer
                    ? 'Correct!'
                    : 'Wrong! Correct answer: ${_currentMatch.correctAnswer}',
                style: TextStyle(
                  fontSize: 18,
                  color: _selectedAnswer == _currentMatch.correctAnswer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: widget.onRefresh,
              child: const Text('Next Word'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: PageHeader(widget.isSynonymMode ? 'Synonym Match' : 'Antonym Match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: widget.onToggleMode,
          ),
          ProfileMenu(),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: buildBody(),
    );
  }
}