import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/word_match/services/ai_word_match_service.dart';
import 'package:flutter/material.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordMatch extends StatefulWidget {
  const WordMatch({super.key});

  @override
  State<WordMatch> createState() => _WordMatchState();
}

class _WordMatchState extends State<WordMatch> {
  final _service = AiWordMatchService();
  late Future<Result<WordMatchData, String>> _matchFuture;
  bool _isSynonymMode = true;
  int _score = 0;
  int _highestScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighestScore();
    _matchFuture = _service.generateWordMatch(isSynonymMode: _isSynonymMode);
  }

  Future<void> _loadHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highestScore = prefs.getInt('word_match_highest_score') ?? 0;
    });
  }

  Future<void> _saveHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (_score > _highestScore) {
      setState(() {
        _highestScore = _score;
      });
      await prefs.setInt('word_match_highest_score', _highestScore);
    }
  }

  void _refreshMatch({bool resetScore = false}) {
    setState(() {
      if (resetScore) {
        _score = 0;
      }
      _matchFuture = _service.generateWordMatch(isSynonymMode: _isSynonymMode);
    });
  }

  void _toggleMode() {
    setState(() {
      _isSynonymMode = !_isSynonymMode;
      _refreshMatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: PageHeader("Word Match: ${_isSynonymMode ? "Synonym" : "Antonym"}"),
        actions: const [
          ProfileMenu(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<Result<WordMatchData, String>>(
            future: _matchFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final res = snapshot.requireData;
                if (res.isError) {
                  return Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text("Word Match is not available"),
                            Text(res.unwrapError()),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return WordMatchScreen(
                  initialMatch: res.unwrap(),
                  isSynonymMode: _isSynonymMode,
                  onRefresh: _refreshMatch,
                  onToggleMode: _toggleMode,
                  score: _score,
                  highestScore: _highestScore,
                  onScoreUpdate: (int newScore) {
                    setState(() {
                      _score = newScore;
                      _saveHighestScore();
                    });
                  },
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("Word Match is not available"),
                          Text(snapshot.error.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class WordMatchScreen extends StatelessWidget {
  final WordMatchData initialMatch;
  final bool isSynonymMode;
  final void Function({bool resetScore}) onRefresh;
  final void Function() onToggleMode;
  final int score;
  final int highestScore;
  final Function(int) onScoreUpdate;

  const WordMatchScreen({
    super.key,
    required this.initialMatch,
    required this.isSynonymMode,
    required this.onRefresh,
    required this.onToggleMode,
    required this.score,
    required this.highestScore,
    required this.onScoreUpdate,
  });

  void _handleAnswer(BuildContext context, String selectedAnswer) {
    final isCorrect = selectedAnswer == initialMatch.correctAnswer;
    if (isCorrect) {
      onScoreUpdate(score + 1);
      context.read<AppState>().addWordToLearned(initialMatch.word);
      onRefresh();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("You lost :("),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRefresh(resetScore: true);
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "Score: $score",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Highest: $highestScore",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Switch Mode: ",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz, size: 30),
                          onPressed: onToggleMode,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  initialMatch.word.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: initialMatch.answerOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(context, option),
                          child: Text(option),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}