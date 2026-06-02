import 'package:flutter/material.dart';

// 1. Import the Engine and the auto-generated Registry
import 'package:genui_engine/genui_engine.dart';
import 'genui_registry.g.dart';

import 'llm_raw_widget.dart';
import 'llm_stream_widget.dart';

void main() {
  // 2. Instantiate the Engine and inject the global registry.
  // This gives the engine knowledge of every @generativeUI widget in the app.
  final engine = GenUIEngine(registry: globalGenUIRegistry);

  debugPrint('=========================================');
  debugPrint('🤖 LLM SYSTEM PROMPT GENERATED AUTOMATICALLY');
  debugPrint('=========================================');
  debugPrint(engine.buildSystemPrompt());
  debugPrint('=========================================');

  runApp(MainApp(engine: engine));
}

class MainApp extends StatelessWidget {
  final GenUIEngine engine;
  final bool simulateLlmStream;

  const MainApp({
    super.key,
    required this.engine,
    this.simulateLlmStream = true,
  });

  // 3. Define your mock JSON payload as a single source of truth.
  // You can edit these literals here and they will update both tests!
  static const String mockJsonString = '''
{
  "type": "UserCardWidget",
  "properties": {
    "name": "Ada Lovelace",
    "role": "Lead Architect",
    "isActive": true
  }
}
''';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GenUI Engine Demo'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Rendered purely from JSON:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // 4. Pass the raw JSON to the engine. It returns a native Widget!
                  if (simulateLlmStream)
                    LlmStreamWidget(
                      engine: engine,
                      rawJsonString: mockJsonString,
                    )
                  else
                    LlmRawWidget(engine: engine, text: mockJsonString),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
