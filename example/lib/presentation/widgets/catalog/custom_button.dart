import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'custom_button.genui.g.dart';

@generativeUI
/// A custom interactive button widget that renders a labeled elevated button.
/// Supports a custom label, flexible color parsing, and click event callbacks.
class CustomButton extends StatelessWidget {
  final String label;

  /// The background color of the button.
  final Color? color;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? const Color(0xFF6366F1);
    final foregroundColor =
        ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.light
        ? Colors.black87
        : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
