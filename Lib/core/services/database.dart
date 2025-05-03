// database use for cache word and save learned words
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_info.dart';
import 'package:path_provider/path_provider.dart';

enum DatabaseField { cache, learned }

class Database {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get _basePath async {
    return "${await _localPath}/app_ta";
  }

  Future<void> writeCache(List<WordInfo> words) async {
    if (words.isEmpty) return;

    final directory = Directory("${await _basePath}/cache");
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
      log("cannot find cache folder, created one");
    }

    var file = File("${directory.path}/${words[0].word}.json");
    await file.writeAsString(
      jsonEncode(words.map((item) => item.toJson()).toList()),
    );
    log("File saved at: ${file.path}");
  }

  Future<void> writeLearned(List<String> learnedWords) async {
    var file = File("${await _basePath}/learned.json");
    var json = jsonEncode(learnedWords);
    await file.writeAsString(json);
    log("Attempted to add saved learnedWord to: ${file.path}");
  }

  Future<Result<List<WordInfo>, String>> getCache(String word) async {
    final directory = Directory("${await _basePath}/cache");
    if (!(await directory.exists())) {
      log("cannot find cache folder");
      return Result.err("cannot find cache folder when trying to get");
    }

    var file = File("${directory.path}/$word.json");
    if (!(await file.exists())) {
      log("cannot find file");
      return Result.err("Cannot find file $word.json");
    }

    var json = jsonDecode(await file.readAsString());
    var wordInfo = (json as List).map((j) => WordInfo.fromJson(j)).toList();
    return Result.ok(wordInfo);
  }

  Future<Result<List<String>, String>> getLearnedWords() async {
    var file = File("${await _basePath}/learned.json");
    if (!(await file.exists())) {
      log("cannot find file learned");
      return Result.err("Cannot find file learned.json");
    }

    var json = await file.readAsString();
    var wordInfos = (jsonDecode(json) as List).cast<String>();
    return Result.ok(wordInfos);
  }
}
