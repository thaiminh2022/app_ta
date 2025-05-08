import 'package:flutter/material.dart';

class VirtualKeyboard extends StatelessWidget {
  final Function(String) onKeyPress;
  final Map<String, String> usedLetters;

  const VirtualKeyboard({
    super.key,
    required this.onKeyPress,
    required this.usedLetters,
  });

  final List<List<String>> rows = const [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACK'],
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          rows.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      row.map((key) {
                        final isSpecialKey = key == 'ENTER' || key == 'BACK';
                        final keyWidth =
                            isSpecialKey
                                ? screenWidth * 0.12
                                : screenWidth * 0.085;

                        final keyHeight = keyWidth * 1.2;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ElevatedButton(
                            onPressed: () => onKeyPress(key),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE6BE8A),
                              foregroundColor: Colors.black,
                              minimumSize: Size(keyWidth, keyHeight),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              key == 'BACK' ? '⌫' : key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: keyWidth * 0.38,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            );
          }).toList(),
    );
  }
}
