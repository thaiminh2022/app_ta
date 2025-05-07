import 'dart:convert';

import 'package:app_ta/core/models/result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiChatService {
  Future<Result<String, String>> sendChatMessage(String message) async {
    final apiKey = dotenv.env['GEMINI_API'];
    const apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Bạn là app học tiếng anh DailyE, hãy trợ giúp người dùng trả lời những câu hỏi thật ngắn gọn, chính xác, đồng thời trả lời bằng tiếng việt, giới hạn trong 15 dòng. User question: $message',
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String rawResponse = data['candidates'][0]['content']['parts'][0]['text'];
      List<String> lines = rawResponse.split('\n');
      lines =
          lines
              .where(
                (line) =>
                    !line.contains(
                      'Bạn cần cung cấp thêm ngữ cảnh để có bản dịch chính xác nhất',
                    ),
              )
              .toList();
      if (lines.length > 15) {
        rawResponse = lines.sublist(0, 15).join('\n');
      } else {
        rawResponse = lines.join('\n');
      }
      return Result.ok(rawResponse);
    } else {
      return Result.err(
        "Error: Could not get response from AI. Status: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
