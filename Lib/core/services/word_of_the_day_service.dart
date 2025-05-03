import 'dart:convert';
import 'dart:math';
// import 'package:app_ta/core/models/result.dart';
// import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/models/word_of_the_day.dart';
import 'package:app_ta/core/services/dictionary_api.dart';
import 'package:flutter/services.dart' show rootBundle;

class WordOfTheDayService {
  final List<String> _allWords = [];
  final DictionaryApi _dictApi = DictionaryApi();

  Future<void> loadWordsFromCsv() async {
    if (_allWords.isNotEmpty) return;
    final csvData = await rootBundle.loadString('assets/words.csv');
    final lines = const LineSplitter().convert(csvData);
    for (var line in lines.skip(1)) {
      final cols = line.split(',');
      _allWords.add(cols[1].replaceAll('"', '').trim());
    }
  }

  /// Trả về một từ ngẫu nhiên chưa học
  String getRandomWord(List<String> learnedWords) {
    final unseen = _allWords.where((w) => !learnedWords.contains(w)).toList();
    if (unseen.isEmpty) return '';
    return unseen[Random().nextInt(unseen.length)];
  }

  /// Trả về full WordOfTheDay (word + ipa + meaning + example)
  Future<WordOfTheDay?> getWordOfTheDay(List<String> learnedWords) async {
  await loadWordsFromCsv();
  const maxTries = 5;

  for (int i = 0; i < maxTries; i++) {
    final word = getRandomWord(learnedWords);
    if (word.isEmpty) return null;

    final res = await _dictApi.searchWord(word);
    if (res.isError) continue;

    final infos = res.unwrap();
    if (infos.isEmpty) continue;

    final info = infos.first;

    return WordOfTheDay(
      word: info.word,
      ipa: info.phonetics.isNotEmpty ? info.phonetics.first.text ?? '' : '',
      meaning: info.meanings.first.definitions.first.definition,
      example: info.meanings.first.definitions.first.example ?? '',
    );
  }

  return null; // nếu thử 5 lần vẫn không được
}

}
