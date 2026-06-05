import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An overlay modal dialog presenting the expanded view of the JSON inspector.
class ExpandedInspectorDialog extends StatefulWidget {
  const ExpandedInspectorDialog({
    super.key,
    required this.initialTab,
    required this.payloadJson,
    required this.schemaJson,
    required this.globalSchemasJson,
    required this.onTabChanged,
  });

  final int initialTab;
  final String payloadJson;
  final String schemaJson;
  final String globalSchemasJson;
  final ValueChanged<int> onTabChanged;

  @override
  State<ExpandedInspectorDialog> createState() =>
      _ExpandedInspectorDialogState();
}

class _ExpandedInspectorDialogState extends State<ExpandedInspectorDialog> {
  late int _activeTab;
  final ScrollController _dialogScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void dispose() {
    _dialogScrollController.dispose();
    super.dispose();
  }

  String _getActiveJson() {
    switch (_activeTab) {
      case 0:
        return widget.payloadJson;
      case 1:
        return widget.schemaJson;
      case 2:
        return widget.globalSchemasJson;
      default:
        return '';
    }
  }

  String _getActiveTitle() {
    switch (_activeTab) {
      case 0:
        return 'A2UI PAYLOAD';
      case 1:
        return 'WIDGET SCHEMA';
      case 2:
        return 'GLOBAL CONTRACT';
      default:
        return '';
    }
  }

  void _handleCopy() {
    final activeJson = _getActiveJson();
    Clipboard.setData(ClipboardData(text: activeJson));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied ${_getActiveTitle().toLowerCase()} to clipboard!',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      insetPadding: isMobile
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Container(
        width: isMobile ? double.infinity : mediaQuery.size.width * 0.8,
        height: isMobile ? double.infinity : mediaQuery.size.height * 0.85,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.code_rounded,
                      color: Color(0xFF06B6D4),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EXPANDED INSPECTOR',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                      tooltip: 'Copy active JSON',
                      onPressed: _handleCopy,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Custom Segmented Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildTab(0, 'A2UI Payload'),
                  _buildTab(1, 'Schema'),
                  _buildTab(2, 'Global JSON'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Expanded Code Viewer
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Scrollbar(
                  controller: _dialogScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _dialogScrollController,
                    child: SelectableText(
                      _getActiveJson(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFFA5F3FC),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
          widget.onTabChanged(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: const Color(0x336366F1))
                : Border.all(color: Colors.transparent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF818CF8) : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
