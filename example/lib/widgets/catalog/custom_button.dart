import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'custom_button.genui.g.dart';

@generativeUI
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
