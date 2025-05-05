import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/models/word_cerf_result.dart';
import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/services/cerf.dart';
import 'package:app_ta/core/services/database.dart';
import 'package:app_ta/core/services/dictionary_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final DictionaryApi _dictApi = DictionaryApi();
  final Database _db = Database();
  final CerfReader _cerfReader = CerfReader();

  var learnedWords = <String>[];
  ThemeMode _themeMode = ThemeMode.light; // Default to system theme
  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  Future<void> loadTheme() async {
    var prefs = await SharedPreferences.getInstance();
    var res = prefs.getString("theme_mode");

    if (res != null) {
      switch (res) {
        case "dark":
          _themeMode = ThemeMode.dark;
          break;
        case "light":
          _themeMode = ThemeMode.light;
          break;
        default:
          _themeMode = ThemeMode.light;
      }
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    var prefs = await SharedPreferences.getInstance();
    _themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    prefs.setString("theme_mode", _themeMode.name);

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future<WordCerfResult> getRandomWordCerf() async {
    await _cerfReader.cacheWordCerf();
    var wordList = _cerfReader.cacheWordCerfModel;
    var randWord = wordList[Random().nextInt(wordList.length)].word;
    var cerfRes = await _cerfReader.getWordCerf(randWord);

    return WordCerfResult(word: randWord, cerf: cerfRes);
  }

  Future<WordCerf> getWordCerf(String word) async {
    return await _cerfReader.getWordCerf(word);
  }

  Future<Result<List<WordInfo>, String>> searchWord(String word) async {
    word = word.trim();
    var res = await _db.getCache(word);
    if (res.isError) {
      var wordDatas = await _dictApi.searchWord(word);
      if (wordDatas.isError) {
        return Result.err(
          "Cannot fetch word nor get cache, error: ${wordDatas.error} and ${res.error}",
        );
      }
      var info = wordDatas.unwrap();
      await _db.writeCache(info);
      return Result.ok(info);
    }
    return res;
  }

  Future<void> loadLearnedWords() async {
    var res = await _db.getLearnedWords();
    if (res.isError) {
      learnedWords = [];
    } else {
      learnedWords = res.unwrap();
    }
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
}
