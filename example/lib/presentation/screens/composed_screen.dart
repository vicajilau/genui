import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/api_key_service.dart';
import '../../data/services/gemini_service.dart';
import '../controllers/gemini_chat_controller.dart';
import '../widgets/api_key_warning_card.dart';
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
  final ApiKeyService _apiKeyService = ApiKeyService();
  final GeminiService _geminiService = GeminiService();
  late final GeminiChatController _chatController;

  // App States
  String _geminiApiKey = '';
  bool _isSettingsDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initialize the Chat Controller with dynamic API Key getter
    _chatController = GeminiChatController(
      geminiService: _geminiService,
      getApiKey: () => _geminiApiKey,
    );

    _loadStoredApiKey();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
    if (_tabController.indexIsChanging) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (_tabController.index == 1 && !_tabController.indexIsChanging) {
      _promptForApiKeyIfNeeded();
    }
  }

  Future<void> _loadStoredApiKey() async {
    final key = await _apiKeyService.getApiKey();
    if (key != null && key.isNotEmpty && mounted) {
      setState(() {
        _geminiApiKey = key;
      });
    } else {
      _promptForApiKeyIfNeeded();
    }
  }

  Future<void> _saveApiKey(String key) async {
    await _apiKeyService.saveApiKey(key);
    if (mounted) {
      setState(() {
        _geminiApiKey = key;
      });
    }
  }

  Future<void> _deleteApiKey() async {
    await _apiKeyService.deleteApiKey();
    if (mounted) {
      setState(() {
        _geminiApiKey = '';
      });
      _promptForApiKeyIfNeeded();
    }
  }

  Future<void> _showSettingsDialog() async {
    if (_isSettingsDialogOpen || !mounted) {
      return;
    }

    _isSettingsDialogOpen = true;
    try {
      await showDialog(
        context: context,
        builder: (context) => SettingsDialog(
          initialApiKey: _geminiApiKey,
          onValidate: _apiKeyService.isValidApiKey,
          onSave: _saveApiKey,
          onDelete: _deleteApiKey,
          isChatVisible: _tabController.index == 1 && _geminiApiKey.isNotEmpty,
        ),
      );
    } finally {
      _isSettingsDialogOpen = false;
    }
  }

  void _promptForApiKeyIfNeeded() {
    if (!mounted ||
        _tabController.index != 1 ||
        _geminiApiKey.isNotEmpty ||
        _isSettingsDialogOpen) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _geminiApiKey.isEmpty && !_isSettingsDialogOpen) {
        _showSettingsDialog();
      }
    });
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

  @override
  Widget build(BuildContext context) {
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
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard_customize),
              text: 'Component Catalog',
            ),
            Tab(icon: Icon(Icons.forum_outlined), text: 'Gemini AI Chat'),
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
    if (_geminiApiKey.isEmpty) {
      return ApiKeyWarningCard(
        onValidate: _apiKeyService.isValidApiKey,
        onSave: _saveApiKey,
        onOpenSettings: _showSettingsDialog,
      );
    }

    return ListenableBuilder(
      listenable: _chatController,
      builder: (context, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _chatController.chatHistory.length,
                itemBuilder: (context, index) {
                  return ChatMessageBubble(
                    item: _chatController.chatHistory[index],
                    controller: _chatController.aiController,
                  );
                },
              ),
            ),
            if (_chatController.isWaiting)
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
            if (_chatController.hasError)
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
                              _chatController.lastErrorMessage ??
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
                          _chatController.retry();
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
                _chatController.sendUserPrompt(prompt);
                _scrollToBottom();
              },
              onClear: _chatController.clearChat,
              autofocus: _tabController.index == 1,
            ),
          ],
        );
      },
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
