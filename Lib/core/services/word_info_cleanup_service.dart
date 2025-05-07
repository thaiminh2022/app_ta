import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_info.dart';

class WordInfoCleanupService {
  Result<WordInfoUsable, String> cleanUp(List<WordInfo> infos) {
    if (infos.isEmpty) {
      Result.err("no infos");
    }

    String word = infos.first.word;
    Map<String, List<WordDefinition>> meanings = {};
    Map<String, WordPhonetic> phonetics = {};

    for (var w in infos) {
      // meaning
      for (var m in w.meanings) {
        Set<WordDefinition> definitions = {};
        definitions.addAll(
          m.definitions.map((v) {
            return WordDefinition(definition: v.definition, exmaple: v.example);
          }),
        );

        if (meanings.containsKey(m.partOfSpeech)) {
          meanings[m.partOfSpeech]!.addAll(definitions);
        } else {
          meanings[m.partOfSpeech] = [...definitions];
        }
      }
      // phonetics
      for (var p in w.phonetics) {
        if (p.text == null) continue;

        phonetics[p.text!] = WordPhonetic(audio: p.audio);
      }
    }

    return Result.ok(
      WordInfoUsable(word: word, phonetics: phonetics, meanings: meanings),
    );
  }
}

class WordInfoUsable {
  String word;
  Map<String, List<WordDefinition>> meanings;
  Map<String, WordPhonetic> phonetics;

  WordInfoUsable({
    required this.word,
    required this.meanings,
    required this.phonetics,
  });
}

class WordPhonetic {
  String audio;
  WordPhonetic({required this.audio});
}

class WordDefinition {
  String definition;
  String? exmaple;

  WordDefinition({required this.definition, this.exmaple});
}
