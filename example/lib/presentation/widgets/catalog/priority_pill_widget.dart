import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'priority_pill_widget.genui.g.dart';

@generativeUI
/// A custom premium priority badge/pill widget.
class PriorityPillWidget extends StatelessWidget {
  final String priority;
  final String? label;

  const PriorityPillWidget({super.key, required this.priority, this.label});

  @override
  Widget build(BuildContext context) {
    final lowerPriority = priority.toLowerCase().trim();
    final displayName =
        label ??
        (lowerPriority.isNotEmpty
            ? '${lowerPriority[0].toUpperCase()}${lowerPriority.substring(1)}'
            : 'Unknown');

    // Colors mapping based on priority
    final (baseColor, bgColor) = (() {
      switch (lowerPriority) {
        case 'high':
          return (const Color(0xFFEF4444), const Color(0x1AEF4444)); // Red
        case 'medium':
          return (const Color(0xFFF59E0B), const Color(0x1AF59E0B)); // Amber
        case 'low':
          return (const Color(0xFF3B82F6), const Color(0x1A3B82F6)); // Blue
        default:
          return (
            const Color(0xFF94A3B8),
            const Color(0x1A94A3B8),
          ); // Slate/Grey
      }
    })();

    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: baseColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: baseColor.withValues(alpha: 0.1),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicator Dot with soft glow
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor,
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Text Label
            Text(
              displayName.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: baseColor,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
