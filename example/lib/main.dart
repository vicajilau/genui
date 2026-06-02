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

class MainApp extends StatefulWidget {
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
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late bool _simulateStream;
  bool _hasStarted = false;
  Key _widgetKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _simulateStream = widget.simulateLlmStream;
  }

  void _startOrRestart() {
    setState(() {
      _hasStarted = true;
      _widgetKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GenUI Demo'),
          backgroundColor: Colors.blueGrey,
          actions: [
            Row(
              children: [
                const Text('Static', style: TextStyle(color: Colors.white)),
                Switch(
                  value: _simulateStream,
                  activeThumbColor: Colors.white,
                  onChanged: (val) {
                    setState(() {
                      _simulateStream = val;
                      _hasStarted = false; // Reset on toggle
                    });
                  },
                ),
                const Text('Stream', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _startOrRestart,
          icon: Icon(_hasStarted ? Icons.refresh : Icons.play_arrow),
          label: Text(_hasStarted ? 'Restart' : 'Start'),
        ),
        body: Center(
          child: !_hasStarted
              ? const Text(
                  'Press Start to render the UI from JSON',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              : SingleChildScrollView(
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
                        if (_simulateStream)
                          LlmStreamWidget(
                            key: _widgetKey,
                            engine: widget.engine,
                            rawJsonString: MainApp.mockJsonString,
                          )
                        else
                          LlmRawWidget(
                            key: _widgetKey,
                            engine: widget.engine,
                            text: MainApp.mockJsonString,
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
