// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String downloadingFile(String fileName) {
    return 'Downloading \"$fileName\"...';
  }

  @override
  String downloadSuccess(String fileName) {
    return '\"$fileName\" downloaded successfully!';
  }

  @override
  String get defaultFileName => 'file';

  @override
  String get alertDismissedLocally => 'Alert dismissed locally.';

  @override
  String actionExecuted(String actionLabel) {
    return 'Action executed: \"$actionLabel\"';
  }

  @override
  String get defaultActionLabel => 'Action';

  @override
  String timelineStatusUpdated(String eventTitle) {
    return 'Status of \"$eventTitle\" updated.';
  }

  @override
  String get processingSecurePayment => 'Processing secure payment...';

  @override
  String get paymentSuccessful =>
      'Payment successful! Your invoice has been settled.';

  @override
  String buttonPressed(String label) {
    return 'Button pressed: \"$label\"';
  }

  @override
  String get defaultButtonLabel => 'Button';

  @override
  String get appTitle => 'GenUI Playground';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get componentCatalogTab => 'Component Catalog';

  @override
  String get aiChatTab => 'AI Chat';

  @override
  String get geminiChatTab => 'Gemini AI Chat';

  @override
  String get localGemmaChatTab => 'Local Gemma Chat';

  @override
  String get serverpodChatTab => 'Serverpod Chat';

  @override
  String get defaultChatHint => 'Ask the model to create widgets...';

  @override
  String get geminiChatHint => 'Ask Gemini to create widgets...';

  @override
  String get localGemmaChatHint => 'Ask Gemma to create widgets...';

  @override
  String get serverpodChatHint => 'Ask Serverpod to create widgets...';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get networkRequestFailed => 'Network request failed.';

  @override
  String get retry => 'Retry';

  @override
  String get settingsTitle => 'Connection Settings';

  @override
  String get activeChatModeLabel => 'Active Chat Execution Mode';

  @override
  String get appPersonaLabel => 'Application Persona / Context';

  @override
  String get taskBoardPersona => 'Task Board';

  @override
  String get customerAppPersona => 'Customer App';

  @override
  String get selectAppLanguage => 'Application Language';

  @override
  String get systemLanguage => 'System Default';

  @override
  String get englishLanguage => 'English';

  @override
  String get spanishLanguage => 'Spanish';

  @override
  String get backendsSection => 'Configure Backends & Endpoints';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get settingsSavedSuccess => 'Settings saved successfully!';

  @override
  String get noChatConnectionTitle => 'No Chat Connection Configured';

  @override
  String get noChatConnectionDescription =>
      'To start using the chat interface and rendering Generative UI in real-time, please open settings and configure at least one of the execution modes:\n\n• Serverless: Enter a Gemini API Key to connect directly from the client.\n• Local Model: Provide a model path (e.g. gemma-2b-it.bin) for on-device inference.\n• Serverpod: Configure a remote Serverpod server URL.';

  @override
  String get serverlessGeminiLabel => 'Serverless Gemini';

  @override
  String get localGemmaLabel => 'Local Gemma';

  @override
  String get serverpodRemoteLabel => 'Serverpod Remote';

  @override
  String get modeServerless => 'Serverless';

  @override
  String get modeLocal => 'Local';

  @override
  String get modeServerpod => 'Serverpod';

  @override
  String get activeModeStatusLabel => 'Active Mode';

  @override
  String get openSettingsButton => 'OPEN SETTINGS';

  @override
  String get clearConversationTooltip => 'Clear Conversation';

  @override
  String get geminiApiKeyLabel => 'Gemini API Key';

  @override
  String get invalidApiKeyFormat => 'Invalid Gemini API Key format';

  @override
  String get pasteKeyButton => 'PASTE KEY';

  @override
  String get getApiKeyButton => 'GET API KEY';

  @override
  String get modelFilePathLabel => 'Model File Path (Assets/Storage)';

  @override
  String get serverHostUrlLabel => 'Server Host endpoint URL';

  @override
  String get temperatureLabel => 'Temperature:';

  @override
  String get testConnectionButton => 'Test Connection';

  @override
  String get testingConnectionProgress => 'Testing connection...';

  @override
  String get apiKeyCannotBeEmpty => 'API key cannot be empty.';

  @override
  String get invalidApiKeyFormatMessage => 'Invalid Gemini API key format.';

  @override
  String get apiKeyFormatIsValid =>
      'API key format is valid! (Mock SSE ping passed)';

  @override
  String get modelPathCannotBeEmpty => 'Model path cannot be empty.';

  @override
  String get modelPathIsValid =>
      'Model file path format is valid! (Mock weight check passed)';

  @override
  String get serverUrlCannotBeEmpty => 'Server URL cannot be empty.';

  @override
  String get serverpodHostReachable =>
      'Serverpod host is reachable! (Mock WebSocket handshake passed)';

  @override
  String get noTextInClipboard => 'No text found in clipboard';

  @override
  String get serverlessGeminiSubtitle => 'Direct SSE connection to Gemini API';

  @override
  String get localGemmaSubtitle => 'Native on-device LLM execution';

  @override
  String get serverpodRemoteSubtitle =>
      'WebSockets streaming via remote backend';

  @override
  String get activeBadgeLabel => 'ACTIVE';

  @override
  String get componentsHeader => 'COMPONENTS';

  @override
  String get hideLabel => 'Hide';

  @override
  String get showLabel => 'Show';

  @override
  String get componentCustomButton => 'Custom Button';

  @override
  String get componentTaskItem => 'Task Item';

  @override
  String get componentStatsSummary => 'Stats Summary';

  @override
  String get componentUserCard => 'User Card';

  @override
  String get componentMetricChart => 'Metric Chart';

  @override
  String get componentPriorityPill => 'Priority Pill';

  @override
  String get componentAttachmentList => 'Attachment List';

  @override
  String get componentSingleAttachment => 'Single Attachment';

  @override
  String get componentQuickReplies => 'Quick Replies';

  @override
  String get componentProductCard => 'Product Card';

  @override
  String get componentTimelineLog => 'Timeline Log';

  @override
  String get componentAlertBanner => 'Alert Banner';

  @override
  String catalogCustomButtonClicked(String label) {
    return 'CustomButton clicked! Label: \"$label\"';
  }

  @override
  String catalogTaskItemToggled(String title) {
    return 'TaskItemWidget checkbox toggled! Title: \"$title\"';
  }

  @override
  String catalogTimelineEventTapped(String eventTitle) {
    return 'Timeline Event tapped: \"$eventTitle\"';
  }

  @override
  String catalogAttachmentItemClicked(String fileName) {
    return 'Attachment item clicked: \"$fileName\"';
  }

  @override
  String catalogAlertActionClicked(String actionLabel) {
    return 'Alert Action clicked! Label: \"$actionLabel\"';
  }

  @override
  String get catalogAlertBannerDismissed => 'Alert Banner dismissed!';

  @override
  String catalogSingleAttachmentTapped(String name) {
    return 'Single Attachment tapped: \"$name\"';
  }

  @override
  String catalogSingleAttachmentActionClicked(String status) {
    return 'Single Attachment action clicked! Status: $status';
  }

  @override
  String catalogQuickReplySelected(String reply) {
    return 'Quick Reply selected: \"$reply\"';
  }

  @override
  String catalogProductTapped(String title) {
    return 'Product tapped: \"$title\"';
  }

  @override
  String catalogProductBought(String price) {
    return 'Product bought! Price: $price';
  }

  @override
  String get catalogA2uiComponentBadge => 'A2UI Component';

  @override
  String get catalogPreviewHeader => 'PREVIEW';

  @override
  String get btnLabelDefault => 'Hello world';

  @override
  String get taskTitleDefault => 'Design Generative UI Architecture';

  @override
  String get pillLabelDefault => 'High Priority';

  @override
  String get attachmentTitleDefault => 'Attachments';

  @override
  String get alertMessageDefault =>
      'System memory is currently running high (85% utilization).';

  @override
  String get alertActionLabelDefault => 'Resolve';

  @override
  String get quickRepliesTitleDefault => 'Select a follow-up action:';

  @override
  String get productTitleDefault => 'Premium Wireless Headphones';

  @override
  String get productDescriptionDefault =>
      'High-fidelity audio with active noise cancellation and 40-hour battery life.';

  @override
  String get projectProposalPdfName => 'Project Proposal.pdf';

  @override
  String get designMockupPngName => 'Design Mockup.png';

  @override
  String get projectInitiatedTitle => 'Project Initiated';

  @override
  String get projectInitiatedDesc => 'Kickoff meeting scheduled with client.';

  @override
  String get designMockupsTitle => 'Design Mockups';

  @override
  String get designMockupsDesc =>
      'Review visual layouts and typography guidelines.';

  @override
  String get apiIntegrationTitle => 'API Integration';

  @override
  String get apiIntegrationDesc =>
      'Connect UI surfaces to local and remote data handlers.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get quickReplyViewPricing => 'View pricing summary';

  @override
  String get quickReplyContactHuman => 'Contact human agent';

  @override
  String get quickReplyRequestCustom => 'Request custom proposal';

  @override
  String get userNameDefault => 'Ada Lovelace';

  @override
  String get userRoleDefault => 'Lead Architect';

  @override
  String get metricTitleDefault => 'Project Completion';

  @override
  String get metricLegendDefault => 'Completed';

  @override
  String get timelineTitleDefault => 'Activity Timeline';

  @override
  String get singleAttachmentNameDefault => 'Quarterly_Report_2026.pdf';

  @override
  String get singleAttachmentSizeDefault => '4.2 MB';
}
