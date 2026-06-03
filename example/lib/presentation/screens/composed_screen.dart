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

class ComposedScreen extends StatefulWidget {
  const ComposedScreen({super.key});

  @override
  State<ComposedScreen> createState() => _ComposedScreenState();
}

class _ComposedScreenState extends State<ComposedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Services & Controllers
  final ApiKeyService _apiKeyService = ApiKeyService();
  final GeminiService _geminiService = GeminiService();
  late final GeminiChatController _chatController;
  StreamSubscription? _errorSubscription;

  // App States
  String _geminiApiKey = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize the Chat Controller with dynamic API Key getter
    _chatController = GeminiChatController(
      geminiService: _geminiService,
      getApiKey: () => _geminiApiKey,
    );

    // Listen to streaming and model errors
    _errorSubscription = _chatController.errors.listen((errorMsg) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI Error: $errorMsg'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    });

    _loadStoredApiKey();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _errorSubscription?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _loadStoredApiKey() async {
    final key = await _apiKeyService.getApiKey();
    if (key != null && key.isNotEmpty && mounted) {
      setState(() {
        _geminiApiKey = key;
      });
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
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        initialApiKey: _geminiApiKey,
        onValidate: _apiKeyService.isValidApiKey,
        onSave: _saveApiKey,
        onDelete: _deleteApiKey,
      ),
    );
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
            const ComponentCatalogView(),

            // Tab 2: Gemini AI Chat
            _buildGeminiChatTab(),
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
            ChatInputBar(
              onSend: (prompt) {
                _chatController.sendUserPrompt(prompt);
                _scrollToBottom();
              },
              onClear: _chatController.clearChat,
            ),
          ],
        );
      },
    );
  }
}
