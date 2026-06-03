// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'custom_button.dart';

// **************************************************************************
// GenerativeUIGenerator
// **************************************************************************

// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names

/// The mapped identifier for CustomButton.
const String $CustomButtonIdentifier = "CustomButton";

/// Event name constants for CustomButton.
abstract class CustomButtonEvents {
  static const String onPressed = 'CustomButton_onPressedEvent';
}

/// Auto-generated CatalogItem for CustomButton.
final CatalogItem $CustomButtonCatalogItem = CatalogItem(
  name: $CustomButtonIdentifier,
  dataSchema: S.object(
    description: "Auto-generated schema for CustomButton.",
    properties: {"label": S.string(description: "The label property.")},
    required: ["label"],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, dynamic>;
    return CustomButton(
      label: data["label"] as String,
      onPressed: () {
        itemContext.dispatchEvent(
          UserActionEvent(
            name: CustomButtonEvents.onPressed,
            sourceComponentId: itemContext.id,
            context: {...data},
          ),
        );
      },
    );
  },
);
