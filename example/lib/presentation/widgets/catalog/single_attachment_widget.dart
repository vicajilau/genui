import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

part 'single_attachment_widget.genui.g.dart';

@generativeUI
/// A custom premium card widget to display a single file attachment.
/// Designed for modern, rich chat feeds.
class SingleAttachmentWidget extends StatelessWidget {
  final String name;
  final String type;
  final String? size;
  final String? status;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const SingleAttachmentWidget({
    super.key,
    required this.name,
    this.type = 'file',
    this.size,
    this.status = 'ready',
    this.onTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedType = (() {
      final t = type.toLowerCase().trim();
      final n = name.toLowerCase().trim();

      // First check if type is explicitly specified and matches a known type pattern.
      if (t == 'pdf' || t == 'application/pdf') {
        return 'pdf';
      }
      if (t == 'image' || t.startsWith('image/')) {
        return 'image';
      }
      if (t == 'audio' || t.startsWith('audio/')) {
        return 'audio';
      }
      if (t == 'video' || t.startsWith('video/')) {
        return 'video';
      }
      if (t == 'document' ||
          t == 'txt' ||
          t == 'text/plain' ||
          t.contains('word')) {
        return 'document';
      }
      if (t == 'spreadsheet' || t.contains('excel') || t.contains('sheet')) {
        return 'spreadsheet';
      }
      if (t == 'archive' || t.contains('zip') || t.contains('compressed')) {
        return 'archive';
      }
      if (t == 'folder') {
        return 'folder';
      }

      // If type is generic ('file') or unrecognized, fallback to name extension checks.
      if (n.endsWith('.pdf')) {
        return 'pdf';
      }
      if (n.endsWith('.png') ||
          n.endsWith('.jpg') ||
          n.endsWith('.jpeg') ||
          n.endsWith('.webp') ||
          n.endsWith('.gif')) {
        return 'image';
      }
      if (n.endsWith('.mp3') ||
          n.endsWith('.wav') ||
          n.endsWith('.m4a') ||
          n.endsWith('.ogg')) {
        return 'audio';
      }
      if (n.endsWith('.mp4') ||
          n.endsWith('.mov') ||
          n.endsWith('.avi') ||
          n.endsWith('.mkv')) {
        return 'video';
      }
      if (n.endsWith('.docx') ||
          n.endsWith('.doc') ||
          n.endsWith('.txt')) {
        return 'document';
      }
      if (n.endsWith('.xlsx') ||
          n.endsWith('.xls') ||
          n.endsWith('.csv')) {
        return 'spreadsheet';
      }
      if (n.endsWith('.zip') ||
          n.endsWith('.tar') ||
          n.endsWith('.gz') ||
          n.endsWith('.rar')) {
        return 'archive';
      }

      return t == 'file' ? 'file' : t;
    })();

    final fileIcon = (() {
      switch (normalizedType) {
        case 'image':
          return Icons.image_outlined;
        case 'pdf':
          return Icons.picture_as_pdf_outlined;
        case 'file':
          return Icons.insert_drive_file_outlined;
        case 'audio':
          return Icons.audio_file_outlined;
        case 'video':
          return Icons.video_file_outlined;
        case 'document':
          return Icons.article_outlined;
        case 'folder':
          return Icons.folder_outlined;
        case 'spreadsheet':
          return Icons.table_chart_outlined;
        case 'archive':
          return Icons.archive_outlined;
        default:
          return Icons.insert_drive_file_outlined;
      }
    })();

    final iconColor = (() {
      switch (normalizedType) {
        case 'image':
          return const Color(0xFF10B981);
        case 'pdf':
          return const Color(0xFFEF4444);
        case 'audio':
          return const Color(0xFFF59E0B);
        case 'video':
          return const Color(0xFF3B82F6);
        case 'document':
          return const Color(0xFFFAF200);
        case 'folder':
          return const Color(0xFFFB8200);
        case 'spreadsheet':
          return const Color(0xFF10B981);
        case 'archive':
          return const Color(0xFF44EF6F);
        default:
          return const Color(0xFF94A3B8);
      }
    })();

    // Status styling
    final (statusIcon, statusColor, isPending) = (() {
      switch (status?.toLowerCase()) {
        case 'downloading':
        case 'pending':
          return (null, Colors.white30, true);
        case 'failed':
          return (Icons.error_outline_rounded, const Color(0xFFEF4444), false);
        case 'downloaded':
        case 'ready':
        default:
          return (Icons.file_open_outlined, Colors.white70, false);
      }
    })();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0x1F1E293B), // Premium Slate translucent
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Icon with Type-Specific color glow
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(fileIcon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              // Name & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (size != null && size!.isNotEmpty) ...[
                          Text(
                            size!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          type.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: iconColor.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action status button
              if (onAction != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: isPending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6366F1),
                                ),
                              ),
                            )
                          : Icon(statusIcon, color: statusColor, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
