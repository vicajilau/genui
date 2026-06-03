// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'task_item_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for TaskItemWidget.
const String $TaskItemWidgetIdentifier = "TaskItemWidget";

/// Event name constants for TaskItemWidget.
abstract class TaskItemWidgetEvents {
  static const String onToggle = 'TaskItemWidget_onToggleEvent';
}

/// Auto-generated CatalogItem for TaskItemWidget.
final CatalogItem $TaskItemWidgetCatalogItem = CatalogItem(
  name: $TaskItemWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for TaskItemWidget.",
    properties: {
      "title": S.string(description: "The title property."),
      "isCompleted": S.boolean(description: "The isCompleted property."),
      "priority": S.string(description: "The priority property."),
    },
    required: ["title", "isCompleted", "priority"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return TaskItemWidget(
      title: data["title"] as String,
      isCompleted: data["isCompleted"] as bool,
      priority: data["priority"] as String,
      onToggle: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: 'TaskItemWidget_onToggleEvent',
            sourceComponentId: itemContext.id,
            context: data,
          ),
        );
      },
    );
  },
);
