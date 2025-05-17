import 'package:flutter/material.dart';

class CefrTest extends StatelessWidget {
  final String level;
  const CefrTest({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thi lên cấp $level')),
      body: Center(
        child: Text(
          'Bài kiểm tra lên cấp $level\n(Placeholder)',
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
