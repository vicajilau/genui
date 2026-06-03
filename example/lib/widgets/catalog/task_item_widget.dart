import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'task_item_widget.genui.g.dart';

@generativeUI
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
    final color = switch (priority) {
      'high' => Colors.red.shade100,
      'medium' => Colors.orange.shade100,
      _ => Colors.blue.shade100,
    };

    return Card(
      color: color,
      child: ListTile(
        leading: Checkbox(value: isCompleted, onChanged: (_) => onToggle()),
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            priority.toUpperCase(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
