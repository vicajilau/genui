// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'user_card_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for UserCardWidget.
const String $UserCardWidgetIdentifier = "UserCardWidget";

/// Auto-generated CatalogItem for UserCardWidget.
final CatalogItem $UserCardWidgetCatalogItem = CatalogItem(
  name: $UserCardWidgetIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for UserCardWidget.",
    properties: {
      "name": S.string(description: "The name property."),
      "role": S.string(description: "The role property."),
      "isActive": S.boolean(description: "The isActive property."),
      "avatarUrl": S.string(description: "The avatarUrl property."),
    },
    required: ["name", "role"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return UserCardWidget(
      name: (data["name"] as String?) ?? "",
      role: (data["role"] as String?) ?? "",
      isActive: (data["isActive"] as bool?) ?? false,
      avatarUrl: data["avatarUrl"] as String?,
    );
  },
);
