// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'user_card_widget.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for UserCardWidget.
const String $UserCardWidgetIdentifier = "UserCardWidget";

/// Auto-generated JSON Schema representation for UserCardWidget.
const Map<String, dynamic> $UserCardWidgetSchema = {
  "type": "UserCardWidget",
  "properties": {"name": "String", "role": "String", "isActive": "bool"},
};

/// Factory function to instantiate UserCardWidget from a JSON map.
UserCardWidget $UserCardWidgetFromJson(Map<String, dynamic> json) {
  return UserCardWidget(
    name: json["name"] as String,
    role: json["role"] as String,
    isActive: json["isActive"] as bool,
  );
}
