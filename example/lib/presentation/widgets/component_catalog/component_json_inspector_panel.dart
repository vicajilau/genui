import 'package:flutter/material.dart';

/// A widget panel that displays the compiled A2UI JSON payload matching
/// the active component's state, and provides a quick copy action button.
class ComponentJsonInspectorPanel extends StatelessWidget {
  const ComponentJsonInspectorPanel({
    super.key,
    required this.jsonStr,
    required this.onCopy,
  });

  final String jsonStr;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x1F1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.code_rounded,
                      color: Color(0xFF06B6D4),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'A2UI PAYLOAD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                  tooltip: 'Copy JSON payload',
                  onPressed: onCopy,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                jsonStr,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFA5F3FC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
