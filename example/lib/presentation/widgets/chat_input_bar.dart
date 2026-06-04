import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom input bar widget at the bottom of the chat interface containing
/// the text input, a clear chat action button, and a gradient submit button.
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onClear;
  final bool autofocus;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onClear,
    this.autofocus = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

/// The active state of [ChatInputBar] that manages the text input controller
/// and submission triggers.
class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
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
    final isDesktop =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;

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
                child: Focus(
                  onKeyEvent: (FocusNode node, KeyEvent event) {
                    final isEnter =
                        event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.numpadEnter;
                    if (isEnter) {
                      final isShiftPressed =
                          HardwareKeyboard.instance.isShiftPressed;
                      if (isShiftPressed) {
                        if (event is KeyDownEvent) {
                          final text = _promptController.text;
                          final selection = _promptController.selection;
                          final start = selection.start;
                          final end = selection.end;
                          if (start < 0 || end < 0) {
                            _promptController.text = '$text\n';
                            _promptController.selection =
                                TextSelection.collapsed(
                                  offset: _promptController.text.length,
                                );
                          } else {
                            final newText = text.replaceRange(start, end, '\n');
                            _promptController.value = TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(
                                offset: start + 1,
                              ),
                            );
                          }

                          // Scroll to bottom if cursor is at or near the end of the text
                          if (start >= text.length - 1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent,
                                );
                              }
                            });
                          }
                        }
                        return KeyEventResult.handled;
                      } else {
                        if (event is KeyDownEvent) {
                          _submit();
                        }
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: _promptController,
                    scrollController: _scrollController,
                    minLines: 1,
                    maxLines: 5,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.multiline,
                    textInputAction: isDesktop
                        ? TextInputAction.send
                        : TextInputAction.newline,
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
                    onSubmitted: null,
                  ),
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
