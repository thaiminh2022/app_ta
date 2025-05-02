import 'dart:convert';
import 'dart:developer'; // Import the logging framework
import 'package:http/http.dart' as http;

class PronunciationService {
  final String baseUrl = "http://127.0.0.1:5000";

  Future<Map<String, dynamic>?> checkPronunciationWithUserText(String targetText, String userText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check_pronunciation'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"target_text": targetText, "user_text": userText}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log("Error checking pronunciation: $e", name: "PronunciationService");
    }
    return null;
  }

  Future<bool> checkPronunciation(String targetText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check_pronunciation'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"target_text": targetText}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      }
      return false;
    } catch (e) {
      log("Error checking pronunciation: $e", name: "PronunciationService");
      return false;
    }
  }

  Future<String?> fetchExampleSentence(String word) async {
    try {
      log("Fetching example sentence for word: $word", name: "PronunciationService");
      final response = await http.get(
        Uri.parse('$baseUrl/example_sentence?word=$word'),
      );
      log("Response status: ${response.statusCode}", name: "PronunciationService");
      log("Response body: ${response.body}", name: "PronunciationService");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sentence'] as String?;
      } else {
        log("Failed to fetch example sentence. Status code: ${response.statusCode}", name: "PronunciationService");
      }
    } catch (e) {
      log("Error fetching example sentence: $e", name: "PronunciationService");
    }
    return null;
  }
}
