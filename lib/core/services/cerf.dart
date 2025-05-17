import 'dart:math';

import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:flutter/services.dart';

class CerfReader {
  final Map<WordCerf, Set<String>> _cacheCerf = {
    WordCerf.a1: {},
    WordCerf.a2: {},
    WordCerf.b1: {},
    WordCerf.b2: {},
    WordCerf.c1: {},
    WordCerf.c2: {},
  };

  Future<void> _loadCerf() async {
    final a1 = await rootBundle.loadString("assets/word_cerf/a1.txt");
    final a2 = await rootBundle.loadString("assets/word_cerf/a2.txt");

    final b1 = await rootBundle.loadString("assets/word_cerf/b1.txt");
    final b2 = await rootBundle.loadString("assets/word_cerf/b2.txt");

    final c1 = await rootBundle.loadString("assets/word_cerf/c1.txt");
    final c2 = await rootBundle.loadString("assets/word_cerf/c2.txt");

    _cacheCerf[WordCerf.a1]?.addAll(a1.split("\n"));
    _cacheCerf[WordCerf.a2]?.addAll(a2.split("\n"));
    _cacheCerf[WordCerf.b1]?.addAll(b1.split("\n"));
    _cacheCerf[WordCerf.b2]?.addAll(b2.split("\n"));
    _cacheCerf[WordCerf.c1]?.addAll(c1.split("\n"));
    _cacheCerf[WordCerf.c2]?.addAll(c2.split("\n"));
  }

  Future<WordCerf> getWordCerf(String word) async {
    if (_cacheCerf.values.first.isEmpty) {
      await _loadCerf();
    }

    for (var p in _cacheCerf.entries) {
      var key = p.key;
      var value = p.value;

      for (var val in value) {
        if (val.trim() == word.trim()) {
          return key;
        }
      }
    }
    print("Did not find the word: $word");
    return WordCerf.unknown;
  }

  Future<Result<String, String>> getRandomWordByCerf(WordCerf cerf) async {
    if (_cacheCerf.values.first.isEmpty) {
      await _loadCerf();
    }
    if (cerf == WordCerf.unknown) {
      return Result.err("NO cerf for this word");
    }

    var wordList = _cacheCerf[cerf]!;
    var word = wordList.elementAt(Random().nextInt(wordList.length));
    return Result.ok(word);
  }
}
