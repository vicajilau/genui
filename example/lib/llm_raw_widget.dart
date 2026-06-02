import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genui_engine/genui_engine.dart';

/// A widget that parses and renders a complete, static JSON payload
/// using the [GenUIEngine], and displays the raw JSON string alongside it.
class LlmRawWidget extends StatelessWidget {
  /// The engine responsible for parsing the JSON payload into native widgets.
  final GenUIEngine engine;

  /// The complete raw JSON string to be parsed.
  final String text;

  const LlmRawWidget({super.key, required this.engine, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Render the actual UI via GenUIEngine (static parse)
        engine.parse(jsonDecode(text) as Map<String, dynamic>),

        const Divider(height: 40),

        // 2. Show the raw JSON
        Text(
          'Raw JSON Payload:\n$text',
          style: const TextStyle(fontFamily: 'monospace', color: Colors.grey),
        ),
      ],
    );
  }
}
