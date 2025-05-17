import 'dart:math';
import 'dart:io';
import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/services/word_info_cleanup_service.dart';

class DictionaryRandomWordService {
  /// Lấy một từ ngẫu nhiên từ file word_cerf/<level>.txt (A1, A2, B1, ...), loại bỏ 'unknown'.
  static Future<Result<WordInfoUsable, String>> getRandomWordByUserCerf(AppState appState) async {
    final userCerf = appState.level;
    if (userCerf == WordCerf.unknown) {
      return Result.err('User CERF level is unknown.');
    }

    // Map enum to file name
    final cerfFile = _cerfFileName(userCerf);
    if (cerfFile == null) {
      return Result.err('No file for CERF level: ${userCerf.name}');
    }
    final filePath = 'word_cerf/$cerfFile.txt';
    final file = File(filePath);
    if (!await file.exists()) {
      return Result.err('Word list file not found for CERF level: ${userCerf.name}');
    }
    final lines = await file.readAsLines();
    final words = lines.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (words.isEmpty) {
      return Result.err('No words found for CERF level: ${userCerf.name}');
    }
    final randWord = words[Random().nextInt(words.length)];
    final wordRes = await appState.searchWord(randWord);
    if (wordRes.isError) {
      return Result.err(wordRes.unwrapError());
    }
    return Result.ok(wordRes.unwrap());
  }

  static String? _cerfFileName(WordCerf cerf) {
    switch (cerf) {
      case WordCerf.a1:
        return 'a1';
      case WordCerf.a2:
        return 'a2';
      case WordCerf.b1:
        return 'b1';
      case WordCerf.b2:
        return 'b2';
      case WordCerf.c1:
        return 'c1';
      case WordCerf.c2:
        return 'c2';
      default:
        return null;
    }
  }
}
