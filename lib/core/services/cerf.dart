import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/models/word_pos.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class CerfReader {
  final List<WordCerfModel> _cacheWordCerfModel = [];
  List<WordPosModel> _cacheWordPosModel = [];

  List<WordCerfModel> get cacheWordCerfModel => _cacheWordCerfModel;

  Future<void> cacheWordCerf() async {
    if (_cacheWordCerfModel.isEmpty) {
      var csvContent = await rootBundle.loadString("assets/words.csv");
      var rows = const CsvToListConverter().convert(csvContent);

      // index  0 is header;
      for (var i = 1; i < rows.length; i++) {
        _cacheWordCerfModel.add(WordCerfModel.fromCsv(rows[i]));
      }
    }
  }

  Future<Result<int, String>> _getWordID(String word) async {
    await cacheWordCerf();
    var idx = _cacheWordCerfModel.indexWhere((e) => e.word == word);

    if (idx < 0) {
      return Result.err("Cannot find word");
    }

    // Id starts at 1
    return Result.ok(idx + 1);
  }

  Future<WordCerf> getWordCerf(String word) async {
    word = word.trim();
    var idRes = await _getWordID(word);
    if (idRes.isError) {
      return WordCerf.unknown;
    }
    var id = idRes.unwrap();

    var cerfs = _cacheWordPosModel;
    if (_cacheWordPosModel.isEmpty) {
      var csvContent = await rootBundle.loadString("assets/word_pos.csv");
      var rows = const CsvToListConverter().convert(csvContent);
      for (var i = 1; i < rows.length; i++) {
        cerfs.add(WordPosModel.fromCsv(rows[i]));
      }
      _cacheWordPosModel = cerfs;
    }
    var idx = cerfs.indexWhere((e) => e.wordId == id);
    if (idx < 0) {
      return WordCerf.unknown;
    }

    switch (cerfs[idx].level.round()) {
      case 1:
        return WordCerf.a1;
      case 2:
        return WordCerf.a2;
      case 3:
        return WordCerf.b1;
      case 4:
        return WordCerf.b2;
      case 5:
        return WordCerf.c1;
      case 6:
        return WordCerf.c2;
      default:
        return WordCerf.unknown;
    }
  }
}
