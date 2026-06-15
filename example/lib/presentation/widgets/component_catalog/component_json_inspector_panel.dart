import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import 'expanded_inspector_dialog.dart';

/// A widget panel that displays compiled JSON outputs (A2UI payloads, component schemas,
/// and global registries) and provides a copy action and an expanded overlay dialog.
class ComponentJsonInspectorPanel extends StatefulWidget {
  const ComponentJsonInspectorPanel({
    super.key,
    required this.payloadJson,
    required this.schemaJson,
    required this.globalSchemasJson,
  });

  final String payloadJson;
  final String schemaJson;
  final String globalSchemasJson;

  @override
  State<ComponentJsonInspectorPanel> createState() =>
      _ComponentJsonInspectorPanelState();
}

class _ComponentJsonInspectorPanelState
    extends State<ComponentJsonInspectorPanel> {
  int _activeTab = 0; // 0: Payload, 1: Schema, 2: Global
  final ScrollController _scrollController = ScrollController();

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _scrollController.dispose();
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

  String _getActiveTitle(AppLocalizations l10n) {
    switch (_activeTab) {
      case 0:
        return l10n.titleA2uiPayload;
      case 1:
        return l10n.titleWidgetSchema;
      case 2:
        return l10n.titleGlobalContract;
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
          l10n.copiedToClipboardMessage(_getActiveTitle(l10n).toLowerCase()),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  void _handleExpand() {
    showDialog(
      context: context,
      builder: (context) => ExpandedInspectorDialog(
        initialTab: _activeTab,
        payloadJson: widget.payloadJson,
        schemaJson: widget.schemaJson,
        globalSchemasJson: widget.globalSchemasJson,
        onTabChanged: (newTab) {
          setState(() {
            _activeTab = newTab;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x1F1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.code_rounded,
                      color: Color(0xFF06B6D4),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.inspectorTitle,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      tooltip: l10n.expandViewerTooltip,
                      onPressed: _handleExpand,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      tooltip: l10n.copyActiveJsonTooltip,
                      onPressed: _handleCopy,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                  _buildTab(0, l10n.tabA2uiPayload),
                  _buildTab(1, l10n.tabWidgetSchema),
                  _buildTab(2, l10n.tabGlobalJson),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Code Viewer
            Container(
              width: double.infinity,
              height: 320,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SelectableText(
                    _getActiveJson(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFFA5F3FC),
                      height: 1.4,
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
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF818CF8) : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
