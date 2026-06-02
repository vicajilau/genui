import 'package:flutter/material.dart';

// 1. Import the Engine and the auto-generated Registry
import 'package:genui_engine/genui_engine.dart';
import 'genui_registry.g.dart';

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

  const MainApp({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    // 3. Mock a JSON response exactly as a local LLM would generate it.
    // Notice how the keys match the variables of your UserCardWidget.
    final mockLlmResponse = {
      "type": "UserCardWidget",
      "properties": {
        "name": "Ada Lovelace",
        "role": "Lead Architect",
        "isActive": true,
      },
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GenUI Engine Demo'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
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
                engine.parse(mockLlmResponse),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
