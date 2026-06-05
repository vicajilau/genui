import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/connection_settings_service.dart';
import '../../data/services/gemini_service.dart';
import '../controllers/gemini_chat_controller.dart';
import '../widgets/connection_warning_card.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/component_catalog_view.dart';

/// The main playground screen container holding the TabBarView, Settings API configuration,
/// the interactive Component Catalog, and the live Gemini AI Chat view.
class ComposedScreen extends StatefulWidget {
  const ComposedScreen({super.key});

  @override
  State<ComposedScreen> createState() => _ComposedScreenState();
}

/// The active state of [ComposedScreen] that initializes controllers, handles key persistence,
/// tab navigation, error popups, and manages the view layout.
class _ComposedScreenState extends State<ComposedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Services & Controllers
  final GeminiService _geminiService = GeminiService();
  ConnectionSettingsService? _settingsService;
  GeminiChatController? _chatController;

  // App States
  bool _isLoadingSettings = true;
  bool _isSettingsDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _initSettingsAndController();
  }

  Future<void> _initSettingsAndController() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsService = ConnectionSettingsService(prefs);
    if (mounted) {
      setState(() {
        _settingsService = settingsService;
        _chatController = GeminiChatController(
          settingsService: settingsService,
          geminiService: _geminiService,
        );
        _isLoadingSettings = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    _chatController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
    if (_tabController.indexIsChanging) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> _showSettingsDialog() async {
    if (_isSettingsDialogOpen || !mounted || _settingsService == null) {
      return;
    }

    _isSettingsDialogOpen = true;
    try {
      final settings = _settingsService!;
      final isChatVisible =
          _tabController.index == 1 &&
          (settings.chatMode != ChatMode.serverless ||
              settings.apiKey.isNotEmpty);

      await showDialog(
        context: context,
        builder: (context) => SettingsDialog(
          settingsService: settings,
          onSave: () async {
            _chatController?.reloadSettings();
            if (mounted) {
              setState(() {});
            }
          },
          isChatVisible: isChatVisible,
        ),
      );
    } finally {
      _isSettingsDialogOpen = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getChatTabLabel() {
    if (_settingsService == null) return 'AI Chat';
    final mode = _settingsService!.hasAnyValidConfig
        ? _settingsService!.activeChatMode
        : _settingsService!.chatMode;
    switch (mode) {
      case ChatMode.serverless:
        return 'Gemini AI Chat';
      case ChatMode.local:
        return 'Local Gemma Chat';
      case ChatMode.serverpod:
        return 'Serverpod Chat';
    }
  }

  String _getChatHintText() {
    if (_settingsService == null) return 'Ask the model to create widgets...';
    final mode = _settingsService!.hasAnyValidConfig
        ? _settingsService!.activeChatMode
        : _settingsService!.chatMode;
    switch (mode) {
      case ChatMode.serverless:
        return 'Ask Gemini to create widgets...';
      case ChatMode.local:
        return 'Ask Gemma to create widgets...';
      case ChatMode.serverpod:
        return 'Ask Serverpod to create widgets...';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSettings) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GenUI Playground'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          tabs: [
            const Tab(
              icon: Icon(Icons.dashboard_customize),
              text: 'Component Catalog',
            ),
            Tab(
              icon: const Icon(Icons.forum_outlined),
              text: _getChatTabLabel(),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF0B0F19), // Obsidian
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Component Catalog
            const KeepAliveWrapper(child: ComponentCatalogView()),

            // Tab 2: Gemini AI Chat
            KeepAliveWrapper(child: _buildGeminiChatTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildGeminiChatTab() {
    final settings = _settingsService!;

    if (!settings.hasAnyValidConfig) {
      return ConnectionWarningCard(
        title: 'No Chat Connection Configured',
        description:
            'To start using the chat interface and rendering Generative UI in real-time, please open settings and configure at least one of the execution modes:\n\n'
            '• Serverless: Enter a Gemini API Key to connect directly from the client.\n'
            '• Local Model: Provide a model path (e.g. gemma-2b-it.bin) for on-device inference.\n'
            '• Serverpod: Configure a remote Serverpod server URL.',
        onOpenSettings: _showSettingsDialog,
      );
    }

    final controller = _chatController!;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          children: [
            _buildChatModeStatusBar(settings),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.chatHistory.length,
                itemBuilder: (context, index) {
                  return ChatMessageBubble(
                    item: controller.chatHistory[index],
                    controller: controller.aiController,
                  );
                },
              ),
            ),
            if (controller.isWaiting)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ),
            if (controller.hasError)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: const Color(0x26EF4444),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x66EF4444)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFF87171),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Connection Error',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.lastErrorMessage ??
                                  'Network request failed.',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.retry();
                          _scrollToBottom();
                        },
                        icon: const Icon(Icons.replay_rounded, size: 16),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ChatInputBar(
              onSend: (prompt) {
                controller.sendUserPrompt(prompt);
                _scrollToBottom();
              },
              onClear: controller.clearChat,
              autofocus: _tabController.index == 1,
              hintText: _getChatHintText(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatModeStatusBar(ConnectionSettingsService settings) {
    final activeMode = settings.activeChatMode;
    final configured = settings.configuredModes;

    IconData modeIcon;
    String modeLabel;
    Color modeColor;

    switch (activeMode) {
      case ChatMode.serverless:
        modeIcon = Icons.cloud_queue;
        modeLabel = 'Serverless Gemini';
        modeColor = const Color(0xFF6366F1);
        break;
      case ChatMode.local:
        modeIcon = Icons.phonelink_setup;
        modeLabel = 'Local Gemma';
        modeColor = const Color(0xFF10B981);
        break;
      case ChatMode.serverpod:
        modeIcon = Icons.dns;
        modeLabel = 'Serverpod Remote';
        modeColor = const Color(0xFF3B82F6);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Color(0xFF0F172A), width: 2.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: modeColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: modeColor,
                    boxShadow: [
                      BoxShadow(
                        color: modeColor,
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(modeIcon, size: 14, color: modeColor),
                const SizedBox(width: 6),
                Text(
                  modeLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: modeColor,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (configured.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ChatMode>(
                  value: activeMode,
                  dropdownColor: const Color(0xFF1E293B),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white60,
                    size: 20,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (newMode) async {
                    if (newMode != null && newMode != activeMode) {
                      await settings.setChatMode(newMode);
                      _chatController?.reloadSettings();
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  items: configured.map((mode) {
                    String label;
                    switch (mode) {
                      case ChatMode.serverless:
                        label = 'Serverless';
                        break;
                      case ChatMode.local:
                        label = 'Local';
                        break;
                      case ChatMode.serverpod:
                        label = 'Serverpod';
                        break;
                    }
                    return DropdownMenuItem<ChatMode>(
                      value: mode,
                      child: Text(label),
                    );
                  }).toList(),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white30,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Active Mode',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A wrapper widget that preserves the state of its child across tab switches
/// by mixing in [AutomaticKeepAliveClientMixin].
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
