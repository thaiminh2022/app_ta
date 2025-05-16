import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

// Fallback list of words with synonyms and antonyms
const Map<String, Map<String, List<String>>> fallbackWords = {
  "happy": {
    "synonyms": ["joyful", "cheerful", "delighted"],
    "antonyms": ["sad", "unhappy", "miserable"],
  },
  "big": {
    "synonyms": ["large", "huge", "enormous"],
    "antonyms": ["small", "tiny", "little"],
  },
  "fast": {
    "synonyms": ["quick", "swift", "rapid"],
    "antonyms": ["slow", "leisurely", "sluggish"],
  },
};

class WordMatchService {
  static const String _baseUrl = 'https://api.datamuse.com/words';

  Future<List<String>> getSynonyms(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?ml=$word'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => item['word'] as String).toList();
      }
    } catch (e) {
      // Fallback to local data if API fails
      return fallbackWords[word]?.containsKey("synonyms") == true
          ? fallbackWords[word]!["synonyms"]!
          : [];
    }
    return [];
  }

  Future<List<String>> getAntonyms(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?rel_ant=$word'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => item['word'] as String).toList();
      }
    } catch (e) {
      // Fallback to local data if API fails
      return fallbackWords[word]?.containsKey("antonyms") == true
          ? fallbackWords[word]!["antonyms"]!
          : [];
    }
    return [];
  }

  Future<List<String>> getRandomWord() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?rel_jja=word&max=100'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final words = data.map((item) => item['word'] as String).toList();
        if (words.isEmpty) return [fallbackWords.keys.elementAt(Random().nextInt(fallbackWords.length))];
        return [words[Random().nextInt(words.length)]];
      }
    } catch (e) {
      // Fallback to a random word from the local list
      return [fallbackWords.keys.elementAt(Random().nextInt(fallbackWords.length))];
    }
    return [fallbackWords.keys.elementAt(Random().nextInt(fallbackWords.length))];
  }
}