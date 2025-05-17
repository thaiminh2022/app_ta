import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/models/word_cerf_result.dart';
import 'package:app_ta/core/providers/app_state.dart';

class TestCase {
  String definition;
  String answer;
  Map<String, bool> option;
  TestCase(this.definition, this.answer, this.option);
}

class CefrLevelUpService {
  List<TestCase> cases = [];
  void setTestCase(List<TestCase> testCase) {
    cases = testCase;
  }

  Future<Result<List<TestCase>, String>> loadTestCase(
    WordCerf level,
    AppState appState,
  ) async {
    List<WordCerfResult> data = [];

    if (level == WordCerf.a1 || level == WordCerf.c2) {
      var resData = await appState.getRandomWordsByCerf(10, level);
      if (resData.isError) {
        return Result.err(resData.unwrapError());
      }

      data = resData.unwrap();
    } else {
      final firstPartRes = await appState.getRandomWordsByCerf(7, level);
      final secondPartRes = await appState.getRandomWordsByCerf(
        3,
        WordCerf.values.elementAt(level.index + 1),
      );

      if (firstPartRes.isError || secondPartRes.isError) {
        return Result.err("${firstPartRes.error} || ${secondPartRes.error}");
      }
      data.addAll(firstPartRes.unwrap());
      data.addAll(secondPartRes.unwrap());
    }

    List<TestCase> data1 = [];
    for (var v in data) {
      var options = <String>[];
      var randList = await appState.getRandomWordsByCerf(3, level);
      if (!randList.isError) {
        options.addAll(randList.unwrap().map((x) => x.wordInfo.word));
      } else {
        print(randList.unwrapError());
      }
      options.add(v.wordInfo.word);
      options.shuffle();

      Map<String, bool> selectOption = {};

      for (var d in options) {
        selectOption[d] = false;
      }

      data1.add(
        TestCase(
          v.wordInfo.meanings.values.first.first.definition,
          v.wordInfo.word,
          selectOption,
        ),
      );
    }

    return Result.ok(data1);
  }

  void toggleChoose(int idx, String word) {
    for (var key in cases[idx].option.keys) {
      cases[idx].option[key] = false;
    }

    var current = cases[idx].option[word]!;
    cases[idx].option[word] = !current;
  }

  bool getChooseInfo(int idx, String word) {
    return cases[idx].option[word]!;
  }

  bool submit() {
    int passCount = 0;
    for (var v in cases) {
      var answer = v.answer;
      for (var k in v.option.keys) {
        if (k == answer && v.option[k]!) {
          passCount++;
          break;
        }
      }
    }
    return passCount == cases.length;
  }
}
