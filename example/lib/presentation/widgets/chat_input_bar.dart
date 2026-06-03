import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onClear;

  const ChatInputBar({super.key, required this.onSend, required this.onClear});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _promptController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E293B), // Slate 800
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white60),
              onPressed: widget.onClear,
              tooltip: 'Clear Conversation',
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Slate 800
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0x336366F1),
                  ), // Subtle Indigo border
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: TextField(
                  controller: _promptController,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ask Gemini to create widgets...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
