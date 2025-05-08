import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:http/http.dart' as http;

class PronunciationChecker extends StatefulWidget {
  const PronunciationChecker({super.key});

  @override
  PronunciationCheckerState createState() => PronunciationCheckerState();
}

class PronunciationCheckerState extends State<PronunciationChecker> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = "";
  final String _targetWord = "example";
  String _exampleSentence = "";
  double _correctnessPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchExampleSentence();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _fetchExampleSentence() async {
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/${_targetWord}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final examples = data[0]['meanings'][0]['definitions'][0]['example'];
        setState(() {
          _exampleSentence = examples ?? _targetWord;
        });
      } else {
        setState(() {
          _exampleSentence = _targetWord;
        });
      }
    } catch (e) {
      setState(() {
        _exampleSentence = _targetWord;
      });
    }
  }

  Future<void> _speakWord() async {
    await _flutterTts.speak(_targetWord);
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
  }

  void _calculateCorrectness() {
    final target = _exampleSentence.toLowerCase();
    final spoken = _spokenText.toLowerCase();
    int matches = 0;

    for (int i = 0; i < spoken.length && i < target.length; i++) {
      if (spoken[i] == target[i]) matches++;
    }

    setState(() {
      _correctnessPercentage = (matches / target.length) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronunciation Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Target Word: $_targetWord',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Example Sentence: $_exampleSentence',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speakWord,
              child: Text('Hear Pronunciation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateCorrectness();
              },
              child: Text('Check Pronunciation'),
            ),
            SizedBox(height: 20),
            Text(
              'You said: $_spokenText',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_spokenText.isNotEmpty)
              Text(
                'Correctness: ${_correctnessPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 18,
                  color: _correctnessPercentage < 30
                      ? Colors.red
                      : _correctnessPercentage < 70
                          ? Colors.yellow
                          : Colors.green,
                ),
              ),
            if (_spokenText.isNotEmpty)
              Text(
                _spokenText.toLowerCase() == _targetWord.toLowerCase()
                    ? 'Correct Pronunciation!'
                    : 'Try Again!',
                style: TextStyle(
                  fontSize: 18,
                  color: _spokenText.toLowerCase() == _targetWord.toLowerCase()
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}