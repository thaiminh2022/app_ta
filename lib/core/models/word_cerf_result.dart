import 'package:app_ta/core/models/word_cerf.dart';
import 'package:app_ta/core/services/word_info_cleanup_service.dart';

class WordCerfResult {
  final WordInfoUsable wordInfo;
  final WordCerf cerf;

  WordCerfResult({required this.wordInfo, required this.cerf});
}
