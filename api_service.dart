import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Lấy từ ngẫu nhiên từ API với độ dài xác định (hỗ trợ từ 1-20 ký tự)
  Future<String> fetchRandomWord(int length) async {
    final response = await http.get(
      Uri.parse('https://random-word-api.herokuapp.com/word?length=$length'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> words = jsonDecode(response.body);
      return words[0].toString().toUpperCase();
    }
    throw Exception('Failed to fetch random word');
  }

  // Lấy định nghĩa từ từ API từ điển
  Future<String> fetchWordDefinition(String word) async {
    final response = await http.get(
      Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        final meanings = data[0]['meanings'];
        if (meanings.isNotEmpty) {
          final definitions = meanings[0]['definitions'];
          if (definitions.isNotEmpty) {
            return definitions[0]['definition'].toString();
          }
        }
      }
      return '';
    }
    return '';
  }
}
