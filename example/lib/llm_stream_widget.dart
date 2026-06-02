import 'package:flutter/material.dart';
import 'package:genui_engine/genui_engine.dart';

/// A widget that simulates a Large Language Model (LLM) streaming a JSON payload
/// token by token, and dynamically renders the UI using the [GenUIEngine].
class LlmStreamWidget extends StatelessWidget {
  /// The engine responsible for parsing the JSON stream into native widgets.
  final GenUIEngine engine;

  /// The complete raw JSON string that will be streamed.
  final String rawJsonString;

  const LlmStreamWidget({
    super.key,
    required this.engine,
    required this.rawJsonString,
  });

  /// Simulates an LLM streaming tokens one by one
  Stream<String> _simulateLlmStream() async* {
    final fullJson =
        '''
    [
      $rawJsonString
    ]
    ''';

    String accumulated = '';
    for (int i = 0; i < fullJson.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50)); // Typing speed
      accumulated += fullJson[i];
      yield accumulated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _simulateLlmStream(),
      builder: (context, snapshot) {
        final currentText = snapshot.data ?? '';
        final isDone = snapshot.connectionState == ConnectionState.done;

        return Column(
          children: [
            // 1. Render the actual UI via GenUIEngine passing the isDone flag
            engine.parseStream(currentText, isDone: isDone),

            const Divider(height: 40),

            // 2. Show the raw incomplete JSON being processed
            Text(
              'Raw Stream Buffer:\n$currentText',
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
