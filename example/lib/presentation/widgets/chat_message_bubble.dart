import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import '../../data/models/chat_timeline_item.dart';

/// A widget that renders a single item in the chat timeline, styled as either
/// a user speech bubble, an AI assistant text bubble, or a custom GenUI Surface.
class ChatMessageBubble extends StatelessWidget {
  final ChatTimelineItem item;
  final SurfaceController controller;

  const ChatMessageBubble({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (item.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48, top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)], // Indigo Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x266366F1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            item.text ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      if (item.surfaceId != null) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B), // Slate 800
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0x3306B6D4),
            ), // Subtle Cyan Border
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: const Color(0xFF0F172A), // Slate 900
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dynamic UI Surface (${item.surfaceId})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF06B6D4),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Surface(
                    surfaceContext: controller.contextFor(item.surfaceId!),
                    actionDelegate: ChatUiActionDelegate(controller),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, right: 48, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Slate 800
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                left: BorderSide(
                  color: const Color(
                    0xFF06B6D4,
                  ).withValues(alpha: .7), // Cyan border
                  width: 3.5,
                ),
              ),
            ),
            child: Text(
              item.text ?? '',
              style: const TextStyle(
                color: Color(0xFFE2E8F0), // Slate 200
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        );
      }
    }
  }
}

class ChatUiActionDelegate implements ActionDelegate {
  final SurfaceController controller;

  const ChatUiActionDelegate(this.controller);

  @override
  bool handleEvent(
    BuildContext context,
    UiEvent event,
    SurfaceContext genUiContext,
    Widget Function(SurfaceDefinition, Catalog, String, DataContext)
    buildWidget,
  ) {
    if (event is! UserActionEvent) return false;

    if (event.name == 'TaskItemWidget_onToggleEvent') {
      final surfaceId = genUiContext.surfaceId;
      final definition = genUiContext.definition.value;
      if (definition == null) return false;

      final componentId = event.sourceComponentId;
      final component = definition.components[componentId];
      if (component == null) return false;

      // 1. Prepare updated components list
      final List<Component> updatedComponents = [];

      // Toggle the target task completion status
      final currentIsCompleted =
          component.properties['isCompleted'] as bool? ?? false;
      final newIsCompleted = !currentIsCompleted;

      final updatedTask = Component(
        id: component.id,
        type: component.type,
        properties: {...component.properties, 'isCompleted': newIsCompleted},
      );
      updatedComponents.add(updatedTask);

      // 2. Count total/completed tasks across all components on this surface
      int totalTasks = 0;
      int completedTasks = 0;

      for (final comp in definition.components.values) {
        if (comp.type == 'TaskItemWidget') {
          totalTasks++;
          final isComp = (comp.id == componentId)
              ? newIsCompleted
              : (comp.properties['isCompleted'] as bool? ?? false);
          if (isComp) {
            completedTasks++;
          }
        }
      }

      // 3. Scan and update any StatsWidget on the surface
      for (final comp in definition.components.values) {
        if (comp.type == 'StatsWidget') {
          updatedComponents.add(
            Component(
              id: comp.id,
              type: comp.type,
              properties: {
                ...comp.properties,
                'totalTasks': totalTasks,
                'completedTasks': completedTasks,
              },
            ),
          );
        }
      }

      // 4. Dispatch UpdateComponents locally
      controller.handleMessage(
        UpdateComponents(surfaceId: surfaceId, components: updatedComponents),
      );

      return true; // Return true to stop network request propagation
    }

    return false;
  }
}
