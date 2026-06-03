import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'task_item_widget.genui.g.dart';

@generativeUI
/// A custom interactive widget representing a single checklist task item.
/// Renders with a title, completion checkbox, and custom priority pill badges.
class TaskItemWidget extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final String priority;
  final VoidCallback onToggle;

  const TaskItemWidget({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.priority,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = switch (priority.toLowerCase()) {
      'high' => const Color(0xFFEF4444), // Vibrant Red
      'medium' => const Color(0xFFF59E0B), // Vibrant Amber
      _ => const Color(0xFF3B82F6), // Vibrant Blue
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x1F1E293B), // Premium Slate translucent
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white30),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Checkbox(
            value: isCompleted,
            activeColor: const Color(0xFF6366F1),
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Colors.white30, width: 1.5),
            onChanged: (_) => onToggle(),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: isCompleted ? Colors.white38 : Colors.white,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white38,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: priorityColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              priority.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: priorityColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
