export 'flashcard_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/services/dictionary_api.dart';

class FlashcardGame extends StatefulWidget {
  const FlashcardGame({super.key});

  @override
  State<FlashcardGame> createState() => _FlashcardGameState();
}

class _FlashcardGameState extends State<FlashcardGame> {
  final List<Map<String, String>> _flashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _autoAddFromLearned = false;
  final Set<String> _addedLearnedWords = {};
  bool _isDialogShowing = false; // Thêm biến cờ

  @override
  void initState() {
    super.initState();
    // Không tự động sync ở đây nữa
  }

  // Use DictionaryApi to fetch the definition for a word
  Future<String> _getDefinition(String word) async {
    try {
      final api = DictionaryApi();
      final result = await api.searchWord(word);
      if (result.isSuccess && result.value != null && result.value!.isNotEmpty) {
        final wordInfo = result.value!.first;
        if (wordInfo.meanings.isNotEmpty && wordInfo.meanings.first.definitions.isNotEmpty) {
          return wordInfo.meanings.first.definitions.first.definition;
        }
      }
      return 'No definition found.';
    } catch (e) {
      return 'No definition found.';
    }
  }

  void _syncWithLearnedWords() async {
    if (_isDialogShowing) return; // Đảm bảo chỉ hiện 1 popup
    final learnedWords = context.read<AppState>().learnedWords;
    final newWords = learnedWords.where((w) => !_addedLearnedWords.contains(w)).toList();
    if (_autoAddFromLearned && newWords.isNotEmpty) {
      for (var word in newWords) {
        final definition = await _getDefinition(word);
        setState(() {
          _flashcards.add({'question': word, 'answer': definition});
          _addedLearnedWords.add(word);
        });
      }
    } else if (newWords.isNotEmpty) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thêm flashcard cho từ đã học?'),
          content: Text('Bạn có muốn thêm flashcard cho các từ vừa học không?\n\n${newWords.join(", ")}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogShowing = false;
              },
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () async {
                for (var word in newWords) {
                  final definition = await _getDefinition(word);
                  setState(() {
                    _flashcards.add({'question': word, 'answer': definition});
                    _addedLearnedWords.add(word);
                  });
                }
                if (!mounted) return;
                Navigator.of(this.context).pop();
                _isDialogShowing = false;
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ).then((_) {
        _isDialogShowing = false;
      });
    }
  }

  void _nextCard() {
    setState(() {
      _showAnswer = false;
      if (_flashcards.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % _flashcards.length;
      }
    });
  }

  void _flipCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _addFlashcard() {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();
    if (question.isNotEmpty && answer.isNotEmpty) {
      setState(() {
        _flashcards.add({'question': question, 'answer': answer});
        _currentIndex = _flashcards.length - 1;
        _showAnswer = false;
        _addedLearnedWords.add(question);
      });
      _questionController.clear();
      _answerController.clear();
      Navigator.of(context).pop();
    }
  }

  void _deleteFlashcard(int index) {
    setState(() {
      if (_flashcards.isNotEmpty) {
        _addedLearnedWords.remove(_flashcards[index]['question']);
        _flashcards.removeAt(index);
        if (_currentIndex >= _flashcards.length) {
          _currentIndex = 0;
        }
      }
    });
  }

  void _showAddFlashcardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addFlashcard,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditFlashcardDialog(int index) {
    final card = _flashcards[index];
    final TextEditingController editQuestionController = TextEditingController(text: card['question']);
    final TextEditingController editAnswerController = TextEditingController(text: card['answer']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editQuestionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: editAnswerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuestion = editQuestionController.text.trim();
              final newAnswer = editAnswerController.text.trim();
              if (newQuestion.isNotEmpty && newAnswer.isNotEmpty) {
                setState(() {
                  _flashcards[index] = {'question': newQuestion, 'answer': newAnswer};
                  _addedLearnedWords.remove(card['question']);
                  _addedLearnedWords.add(newQuestion);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Không tự động sync ở đây nữa
    final card = _flashcards.isNotEmpty ? _flashcards[_currentIndex] : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Game'),
        actions: [
          Row(
            children: [
              const Text('Tự động thêm'),
              Switch(
                value: _autoAddFromLearned,
                onChanged: (val) {
                  setState(() {
                    _autoAddFromLearned = val;
                  });
                  _syncWithLearnedWords();
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: _flashcards.isEmpty
            ? const Text('Chưa có flashcard nào.')
            : GestureDetector(
                onTap: () {
                  _syncWithLearnedWords();
                  _flipCard();
                },
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(24),
                  child: Container(
                    width: 300,
                    height: 200,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            _showAnswer ? card!['answer']! : card!['question']!,
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          right: 48, // Move edit button to the left of delete
                          top: 8,
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditFlashcardDialog(_currentIndex),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFlashcard(_currentIndex),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _showAddFlashcardDialog,
            tooltip: 'Add Flashcard',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'next',
            onPressed: _nextCard,
            tooltip: 'Next Card',
            child: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
