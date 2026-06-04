// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'timeline_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for TimelineWidget.
const String $TimelineWidgetIdentifier = "TimelineWidget";

/// Event name constants for TimelineWidget.
abstract class TimelineWidgetEvents {
  static const String onTapEvent = 'TimelineWidget_onTapEventEvent';
}

/// Auto-generated CatalogItem for TimelineWidget.
final CatalogItem $TimelineWidgetCatalogItem = CatalogItem(
  name: $TimelineWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for TimelineWidget.",
    properties: {
      "events": S.list(description: "The events property."),
      "title": S.string(description: "The title property."),
    },
    required: ["events"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return TimelineWidget(
      events: (data["events"] as List<dynamic>?) ?? const [],
      title: (data["title"] as String?) ?? 'Activity Timeline',
      onTapEvent: (String eventTitle) {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: TimelineWidgetEvents.onTapEvent,
            sourceComponentId: itemContext.id,
            context: {
              ...data,
              ...{'eventTitle': eventTitle},
            },
          ),
        );
      },
    );
  },
);
