import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'stats_widget.genui.g.dart';

@generativeUI
/// A custom progress reporting widget showing completed vs total tasks
/// using a text summary label and a graphical linear progress indicator bar.
class StatsWidget extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const StatsWidget({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$completedTasks/$totalTasks Completed'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
