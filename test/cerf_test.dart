import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/services/cerf.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

late CerfReader _reader;

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    _reader = CerfReader();
  });

  test("Test getting cerf a1", () async {
    var cerfResult = await _reader.getWordCerf("fly");

    expect(cerfResult, WordCerf.a1);
  });

  test("Test getting cerf unknown", () async {
    var cerfResult = await _reader.getWordCerf("hello");
    expect(cerfResult, WordCerf.unknown);
  });
}
