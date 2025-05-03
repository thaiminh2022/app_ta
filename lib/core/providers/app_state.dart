import 'dart:math';

import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/models/word_cerf_result.dart';
import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/models/word_of_the_day.dart';
import 'package:app_ta/core/services/cerf.dart';
import 'package:app_ta/core/services/database.dart';
import 'package:app_ta/core/services/dictionary_api.dart';
import 'package:flutter/material.dart';
import 'package:app_ta/core/services/word_of_the_day_service.dart';

class AppState extends ChangeNotifier {
  final DictionaryApi _dictApi = DictionaryApi();
  final Database _db = Database();
  final CerfReader _cerfReader = CerfReader();

  final WordOfTheDayService _wotdService = WordOfTheDayService();
  var learnedWords = <String>[];

  Future<WordOfTheDay?> getWordOfTheDay() async {
    await _wotdService.loadWordsFromCsv();
    return _wotdService.getWordOfTheDay(learnedWords);
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
      // there's not cache word for it yet
      var wordDatas = await _dictApi.searchWord(word);
      if (wordDatas.isError) {
        // Error fetching word
        return Result.err(
          "Cannot fetch word nor get cache, error: ${wordDatas.error} and ${res.error}",
        );
      }
      var info = wordDatas.unwrap();
      await _db.writeCache(info);
      return Result.ok(info);
    }
    {
      // already there
      return res;
    }
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
