import 'package:flutter/material.dart';
import 'pronunciation_checker.dart';

class PronunciationCheckerScreen extends StatefulWidget {
  const PronunciationCheckerScreen({super.key});

  @override
  PronunciationCheckerScreenState createState() => PronunciationCheckerScreenState();
}

class PronunciationCheckerScreenState extends State<PronunciationCheckerScreen> {
  final _controller = TextEditingController();
  final _service = PronunciationService();
  String? _exampleSentence;
  String? _resultMessage;

  Future<void> _fetchExampleSentence() async {
    final word = _controller.text.trim();
    if (word.isEmpty) return;

    final sentence = await _service.fetchExampleSentence(word);
    setState(() {
      _exampleSentence = sentence ?? "Không tìm thấy câu ví dụ. Vui lòng kiểm tra từ hoặc kết nối mạng.";
    });
  }

  Future<void> _checkPronunciation() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final success = await _service.checkPronunciation(text);
    setState(() {
      _resultMessage = success
          ? "Phát âm chính xác!"
          : "Phát âm chưa đúng. Hãy thử lại.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kiểm tra phát âm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Nhập từ hoặc câu"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchExampleSentence,
              child: Text("Lấy câu ví dụ"),
            ),
            if (_exampleSentence != null) ...[
              SizedBox(height: 16),
              Text("Câu ví dụ: $_exampleSentence"),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPronunciation,
              child: Text("Kiểm tra phát âm"),
            ),
            if (_resultMessage != null) ...[
              SizedBox(height: 16),
              Text("Kết quả: $_resultMessage"),
            ],
          ],
        ),
      ),
    );
  }
}
