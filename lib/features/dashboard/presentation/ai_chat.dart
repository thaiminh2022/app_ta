import 'package:app_ta/features/dashboard/services/ai_chat_service.dart';
import 'package:flutter/material.dart';

class AIChat extends StatefulWidget {
  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _chatController = TextEditingController();
  final _chatService = AiChatService();
  var _aiRes = '';

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(173, 216, 230, 1),
              Color.fromRGBO(135, 206, 235, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat with AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_chatController.text.isEmpty) return;

                      var res = await _chatService.sendChatMessage(
                        _chatController.text,
                      );

                      setState(() {
                        if (res.isError) {
                          _aiRes = res.unwrapError();
                        } else {
                          _aiRes = res.unwrap();
                        }
                      });

                      _chatController.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: _aiRes.isNotEmpty,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _aiRes,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _aiRes = ''; // Add setState to update UI
                        });
                      },
                      tooltip: 'Clear response',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}