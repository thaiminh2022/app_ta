import 'package:flutter/material.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/games/word_match/services/word_match_service.dart';

class WordMatchScreen extends StatefulWidget {
  final String word;

  const WordMatchScreen({super.key, required this.word});

  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen> {
  final WordMatchService _service = WordMatchService();
  List<String> synonyms = [];
  List<String> antonyms = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWordRelations();
  }

  Future<void> _fetchWordRelations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final syn = await _service.getSynonyms(widget.word);
      final ant = await _service.getAntonyms(widget.word);
      setState(() {
        synonyms = syn;
        antonyms = ant;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load word data. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [ProfileMenu()],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(173, 216, 230, 1), Color.fromRGBO(135, 206, 235, 1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              "Word Match",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
                    "Word: ${widget.word}",
                    style: theme.primaryTextTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.primaryTextTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.error,
                      ),
                    )
                  else
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