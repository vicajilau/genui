// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'metric_chart_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for MetricChartWidget.
const String $MetricChartWidgetIdentifier = "MetricChartWidget";

/// Auto-generated CatalogItem for MetricChartWidget.
final CatalogItem $MetricChartWidgetCatalogItem = CatalogItem(
  name: $MetricChartWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for MetricChartWidget.",
    properties: {
      "title": S.string(description: "The title property."),
      "value": S.number(description: "The value property."),
      "legendLabel": S.string(description: "The legendLabel property."),
      "colorHex": S.string(description: "The colorHex property."),
    },
    required: ["title", "value"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return MetricChartWidget(
      title: (data["title"] as String?) ?? "",
      value: ((data["value"] as num?)?.toDouble()) ?? 0.0,
      legendLabel: (data["legendLabel"] as String?) ?? 'Completed',
      colorHex: data["colorHex"] as String?,
    );
  },
);
