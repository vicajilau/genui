import 'package:flutter/material.dart';
import 'package:genui_annotations/genui_annotations.dart';

part 'user_card_widget.genui.g.dart';

@generativeUI
class UserCardWidget extends StatelessWidget {
  final String name;
  final String role;
  final bool isActive;

  const UserCardWidget({
    super.key,
    required this.name,
    required this.role,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(name),
          Text(role),
          Text(isActive ? 'Active' : 'Inactive'),
        ],
      ),
    );
  }
}
