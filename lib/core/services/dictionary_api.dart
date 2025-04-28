import 'dart:convert';
import 'dart:io';

import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_info.dart';
import "package:http/http.dart" as http;

class DictionaryApi {
  Future<Result<List<WordInfo>, int>> searchWord(String word) async {
    var res = await http.get(
      Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/$word"),
    );

    if (res.statusCode != HttpStatus.ok) {
      return Result.err(res.statusCode);
    }
    var decoded = (jsonDecode(res.body) as List).map(
      (json) => WordInfo.fromJson(json),
    );

    return Result.ok(decoded.toList());
  }
}
