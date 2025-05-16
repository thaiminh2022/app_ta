import 'dart:convert';
import 'package:app_ta/core/models/result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiWordMatchService {
  final List<String> _usedWords = [];
  static const int _maxUsedWords = 50; // Limit to avoid excessive memory usage

  Future<Result<WordMatchData, String>> generateWordMatch({
    bool isSynonymMode = true,
  }) async {
    final apiKey = dotenv.env['GEMINI_API'];
    const apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

    // Clean up old words if list gets too long
    if (_usedWords.length >= _maxUsedWords) {
      _usedWords.removeRange(0, _usedWords.length - _maxUsedWords ~/ 2);
    }

    // Generate a new prompt with used words excluded
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final usedWordsPrompt = _usedWords.isNotEmpty
        ? 'Avoid these previously used words: ${_usedWords.join(', ')}.'
        : '';
    final prompt = isSynonymMode
        ? 'Generate a NEW random English word (different from previous calls, including all previously used words) at CEFR A1-B2 level (rarely C1-C2). Use timestamp $timestamp to ensure uniqueness. $usedWordsPrompt Provide exactly 1 correct synonym and 3 incorrect options (not synonyms). Format the response as: Word: [word]\nCorrect Synonym: [syn1]\nIncorrect Options: [opt1], [opt2], [opt3]'
        : 'Generate a NEW random English word (different from previous calls, including all previously used words) at CEFR A1-B2 level (rarely C1-C2). Use timestamp $timestamp to ensure uniqueness. $usedWordsPrompt Provide exactly 1 correct antonym and 3 incorrect options (not antonyms). Format the response as: Word: [word]\nCorrect Antonym: [ant1]\nIncorrect Options: [opt1], [opt2], [opt3]';

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                'Bạn là app học tiếng Anh DailyE, hãy tạo từ và các từ liên quan theo yêu cầu sau, trả lời bằng tiếng Anh, ngắn gọn, chính xác, dưới 15 dòng.\n$prompt',
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String rawResponse = data['candidates'][0]['content']['parts'][0]['text'];
      List<String> lines = rawResponse.split('\n');
      if (lines.length > 15) {
        rawResponse = lines.sublist(0, 15).join('\n');
      }

      try {
        final wordLine = lines.firstWhere((line) => line.startsWith('Word:'));
        final correctLine = lines.firstWhere((line) => line.startsWith(isSynonymMode ? 'Correct Synonym:' : 'Correct Antonym:'));
        final incorrectLine = lines.firstWhere((line) => line.startsWith('Incorrect Options:'));

        final word = wordLine.replaceFirst('Word: ', '').trim();
        _usedWords.add(word); // Add the new word to the used list
        final correctAnswer = correctLine
            .replaceFirst(isSynonymMode ? 'Correct Synonym: ' : 'Correct Antonym: ', '')
            .trim();
        final incorrectOptions = incorrectLine
            .replaceFirst('Incorrect Options: ', '')
            .split(',')
            .map((e) => e.trim())
            .toList();

        if (incorrectOptions.length != 3) {
          return Result.err('API did not provide exactly 3 incorrect options');
        }

        // Combine correct and incorrect options, then shuffle
        final allOptions = [correctAnswer, ...incorrectOptions]..shuffle();
        return Result.ok(WordMatchData(
          word: word,
          answerOptions: allOptions,
          correctAnswer: correctAnswer,
        ));
      } catch (e) {
        return Result.err('Failed to parse API response: $e');
      }
    } else {
      return Result.err(
          'API Error: Status ${response.statusCode} - ${response.body}');
    }
  }
}

class WordMatchData {
  final String word;
  final List<String> answerOptions;
  final String correctAnswer;

  WordMatchData({
    required this.word,
    required this.answerOptions,
    required this.correctAnswer,
  });
}