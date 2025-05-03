import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/services/database.dart';
import 'package:app_ta/core/services/dictionary_api.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final DictionaryApi _dictApi = DictionaryApi();
  final Database _db = Database();

  var learnedWords = <String>[];
  var searchHistory = <String>[];

  Future<Result<List<WordInfo>, String>> searchWord(String word) async {
    word = word.trim();
    print("Searching for word: $word"); // Debug log
    var res = await _db.getCache(word);
    if (res.isError) {
      print("Cache miss: ${res.error}"); // Debug log
      var wordDatas = await _dictApi.searchWord(word);
      if (wordDatas.isError) {
        print("API error: ${wordDatas.error}"); // Debug log
        return Result.err(
          "Cannot fetch word nor get cache, error: ${wordDatas.error} and ${res.error}",
        );
      }
      var info = wordDatas.unwrap();
      print("API success, fetched ${info.length} entries for $word"); // Debug log
      await _db.writeCache(info);
      return Result.ok(info);
    }
    print("Cache hit: Found ${res.unwrap().length} entries for $word"); // Debug log
    return res;
  }

  Future<void> loadLearnedWords() async {
    var res = await _db.getLearnedWords();
    if (res.isError) {
      learnedWords = [];
    } else {
      learnedWords = res.unwrap();
    }
    notifyListeners();
  }

  Future<void> addWordToLearned(String word) async {
    word = word.trim();
    if (!learnedWords.contains(word)) {
      learnedWords.add(word);
      notifyListeners();
    }
    await saveLearnedWords();
  }

  Future<void> removeWordFromLearned(String word) async {
    word = word.trim();
    var success = learnedWords.remove(word);
    if (success) {
      notifyListeners();
      await saveLearnedWords();
    }
  }

  Future<void> saveLearnedWords() async {
    await _db.writeLearned(learnedWords);
  }

  Future<void> addToSearchHistory(String word) async {
    word = word.trim();
    if (!searchHistory.contains(word)) {
      searchHistory.insert(0, word);
      if (searchHistory.length > 15) searchHistory = searchHistory.sublist(0, 15);
      notifyListeners();
    }
  }
}