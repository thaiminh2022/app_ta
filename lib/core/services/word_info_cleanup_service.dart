import 'package:app_ta/core/models/result.dart';
import 'package:app_ta/core/models/word_info.dart';
import 'package:app_ta/core/models/word_cerf.dart';

class WordInfoCleanupService {
  Result<WordInfoUsable, String> cleanUp(List<WordInfo> infos) {
    if (infos.isEmpty) {
      Result.err("no infos");
    }

    String word = infos.first.word;
    Map<String, List<WordDefinition>> meanings = {};
    Map<String, WordPhonetic> phonetics = {};
    Set<String> antonyms = {};
    Set<String> synonyms = {};
    for (var w in infos) {
      // meaning
      for (var m in w.meanings) {
        Set<WordDefinition> definitions = {};

        for (var d in m.definitions) {
          definitions.add(
            WordDefinition(definition: d.definition, exmaple: d.example),
          );

          antonyms.addAll(d.antonyms);
          synonyms.addAll(d.synonyms);
        }

        antonyms.addAll(m.antonyms);
        synonyms.addAll(m.synonyms);

        if (meanings.containsKey(m.partOfSpeech)) {
          meanings[m.partOfSpeech]!.addAll(definitions);
        } else {
          meanings[m.partOfSpeech] = [...definitions];
        }
      }
      // phonetics
      for (var p in w.phonetics) {
        if (p.text == null) continue;

        phonetics[p.text!] = WordPhonetic(
          audio: p.audio.isEmpty ? null : p.audio,
          source: p.sourceUrl,
        );
      }
    }

    return Result.ok(
      WordInfoUsable(
        word: word,
        phonetics: phonetics,
        meanings: meanings,
        synonyms: synonyms,
        antonyms: antonyms,
        cerf: WordCerf.values.first, // Use an appropriate enum value for cerf
      ),
    );
  }
}

class WordInfoUsable {
  String word;
  Map<String, List<WordDefinition>> meanings;
  Map<String, WordPhonetic> phonetics;
  Set<String> antonyms;
  Set<String> synonyms;
  WordCerf cerf;

  WordInfoUsable({
    required this.word,
    required this.meanings,
    required this.phonetics,
    required this.synonyms,
    required this.antonyms,
    required this.cerf,
  });
}

class WordPhonetic {
  String? audio;
  String? source;
  WordPhonetic({required this.audio, required this.source});
}

class WordDefinition {
  String definition;
  String? exmaple;

  WordDefinition({required this.definition, this.exmaple});
}
