import 'dart:convert';
import 'dart:io';

import 'package:app_ta/core/models/random_word_model.dart';
import 'package:app_ta/core/models/result.dart';
import 'package:http/http.dart' as http;

enum RandomWordType { noun, adjective, verb, vocabulary }

class RandomWordService {
  Future<Result<RandomWordModel, String>> getRandom({
    RandomWordType t = RandomWordType.vocabulary,
  }) async {
    var res = await http.get(
      Uri.parse("https://random-words-api.vercel.app/word/english/${t.name}"),
    );
    if (res.statusCode == HttpStatus.ok) {
      return Result.ok(RandomWordModel.fromJson(jsonDecode(res.body)));
    } else {
      return Result.err(
        "Cannot get any random word right now, code: ${res.statusCode}",
      );
    }
  }
}
