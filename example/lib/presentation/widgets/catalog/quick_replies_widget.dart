import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'quick_replies_widget.genui.g.dart';

@generativeUI
/// A custom interactive widget displaying a horizontal list of suggestion chips/buttons
/// that can be tapped to trigger chat interactions.
class QuickRepliesWidget extends StatelessWidget {
  final List<dynamic> replies;
  final String? title;
  final void Function(String reply)? onTapReply;

  const QuickRepliesWidget({
    super.key,
    required this.replies,
    this.title,
    this.onTapReply,
  });

  @override
  Widget build(BuildContext context) {
    final items = replies.map((r) => QuickReplyItem.fromJson(r)).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: items.map((replyItem) {
                if (replyItem.label.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: onTapReply != null
                        ? () => onTapReply!(replyItem.value)
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 13,
                            color: Color(0xFF818CF8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            replyItem.label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A parsed representation of a single quick reply item.
class QuickReplyItem {
  final String label;
  final String value;

  const QuickReplyItem({required this.label, required this.value});

  factory QuickReplyItem.fromJson(dynamic json) {
    if (json is Map) {
      final label =
          (json['label'] as String?) ??
          (json['text'] as String?) ??
          (json['title'] as String?) ??
          '';
      final value = (json['value'] as String?) ?? label;
      return QuickReplyItem(label: label, value: value);
    }
    final str = json.toString();
    return QuickReplyItem(label: str, value: str);
  }
}
