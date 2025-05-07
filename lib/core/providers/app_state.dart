import 'dart:developer';
import 'dart:math';
import 'package:app_ta/core/services/word_info_cleanup_service.dart';
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
  final _dictApi = DictionaryApi();
  final _db = Database();
  final _cerfReader = CerfReader();
  final _wordInfoCleanupService = WordInfoCleanupService();

  var learnedWords = <String>[];
  var _themeMode = ThemeMode.light; // Default to light theme

  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  // New streak properties
  int _streakDays = 0;
  DateTime? _lastStudyDate;

  // Getter for streak
  int get streakDays => _streakDays;

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

  Future<void> loadStreak() async {
    var prefs = await SharedPreferences.getInstance();
    _streakDays = prefs.getInt("streak_days") ?? 0;
    String? lastDateStr = prefs.getString("last_study_date");
    _lastStudyDate = lastDateStr != null ? DateTime.parse(lastDateStr) : null;
    _checkAndUpdateStreak();
    notifyListeners();
  }

  void _checkAndUpdateStreak() {
    final now = DateTime.now();
    if (_lastStudyDate == null) {
      _streakDays = 0;
    } else {
      final difference = now.difference(_lastStudyDate!).inDays;
      if (difference > 1) {
        _streakDays = 0; // Reset streak if more than 1 day has passed
      } else if (difference == 1) {
        _streakDays++; // Increment streak if studied today
      }
    }
    _lastStudyDate = now;
    _saveStreak();
  }

  Future<void> _saveStreak() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("streak_days", _streakDays);
    await prefs.setString("last_study_date", _lastStudyDate!.toIso8601String());
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

  Future<Result<WordInfoUsable, String>> searchWord(String word) async {
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
      return _wordInfoCleanupService.cleanUp(info);
    }
    return _wordInfoCleanupService.cleanUp(res.unwrap());
  }

  Future<void> loadLearnedWords() async {
    var res = await _db.getLearnedWords();
    if (res.isError) {
      learnedWords = [];
    } else {
      learnedWords = res.unwrap();
    }
    _checkAndUpdateStreak(); // Update streak when loading learned words
    notifyListeners();
  }

  Future<void> addWordToLearned(String word) async {
    word = word.trim();
    if (!learnedWords.contains(word)) {
      learnedWords.add(word);
      _checkAndUpdateStreak(); // Update streak when adding a new word
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
