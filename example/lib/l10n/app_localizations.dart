import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Progress message showing file download has started
  ///
  /// In en, this message translates to:
  /// **'Downloading \"{fileName}\"...'**
  String downloadingFile(String fileName);

  /// Success message when file download completes
  ///
  /// In en, this message translates to:
  /// **'\"{fileName}\" downloaded successfully!'**
  String downloadSuccess(String fileName);

  /// Fallback name when filename is missing
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get defaultFileName;

  /// Toast message when an alert banner is closed
  ///
  /// In en, this message translates to:
  /// **'Alert dismissed locally.'**
  String get alertDismissedLocally;

  /// Toast message when an alert action is triggered
  ///
  /// In en, this message translates to:
  /// **'Action executed: \"{actionLabel}\"'**
  String actionExecuted(String actionLabel);

  /// Fallback label when action label is missing
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get defaultActionLabel;

  /// Toast message when a timeline event is tapped
  ///
  /// In en, this message translates to:
  /// **'Status of \"{eventTitle}\" updated.'**
  String timelineStatusUpdated(String eventTitle);

  /// Loading message when payment is processing
  ///
  /// In en, this message translates to:
  /// **'Processing secure payment...'**
  String get processingSecurePayment;

  /// Success message when payment completes
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Your invoice has been settled.'**
  String get paymentSuccessful;

  /// Toast message for general button press
  ///
  /// In en, this message translates to:
  /// **'Button pressed: \"{label}\"'**
  String buttonPressed(String label);

  /// Fallback label when button label is missing
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get defaultButtonLabel;

  /// Main application title
  ///
  /// In en, this message translates to:
  /// **'GenUI Playground'**
  String get appTitle;

  /// Tooltip for the settings button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// Label for the component catalog tab
  ///
  /// In en, this message translates to:
  /// **'Component Catalog'**
  String get componentCatalogTab;

  /// Label for the default AI Chat tab
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChatTab;

  /// Label for the Gemini AI Chat tab
  ///
  /// In en, this message translates to:
  /// **'Gemini AI Chat'**
  String get geminiChatTab;

  /// Label for the Local Gemma Chat tab
  ///
  /// In en, this message translates to:
  /// **'Local Gemma Chat'**
  String get localGemmaChatTab;

  /// Label for the Serverpod Chat tab
  ///
  /// In en, this message translates to:
  /// **'Serverpod Chat'**
  String get serverpodChatTab;

  /// Fallback hint text in the chat input bar
  ///
  /// In en, this message translates to:
  /// **'Ask the model to create widgets...'**
  String get defaultChatHint;

  /// Hint text when Gemini is the active provider
  ///
  /// In en, this message translates to:
  /// **'Ask Gemini to create widgets...'**
  String get geminiChatHint;

  /// Hint text when local Gemma is the active provider
  ///
  /// In en, this message translates to:
  /// **'Ask Gemma to create widgets...'**
  String get localGemmaChatHint;

  /// Hint text when Serverpod is the active provider
  ///
  /// In en, this message translates to:
  /// **'Ask Serverpod to create widgets...'**
  String get serverpodChatHint;

  /// Error banner title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Default connection error description
  ///
  /// In en, this message translates to:
  /// **'Network request failed.'**
  String get networkRequestFailed;

  /// Label for the retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title of the connection settings dialog
  ///
  /// In en, this message translates to:
  /// **'Connection Settings'**
  String get settingsTitle;

  /// Section title for selecting active execution mode
  ///
  /// In en, this message translates to:
  /// **'Active Chat Execution Mode'**
  String get activeChatModeLabel;

  /// Section title for app persona context selection
  ///
  /// In en, this message translates to:
  /// **'Application Persona / Context'**
  String get appPersonaLabel;

  /// Label for the Task Board app persona
  ///
  /// In en, this message translates to:
  /// **'Task Board'**
  String get taskBoardPersona;

  /// Label for the Customer Portal app persona
  ///
  /// In en, this message translates to:
  /// **'Customer App'**
  String get customerAppPersona;

  /// Label for app language selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get selectAppLanguage;

  /// Dropdown option for system default language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemLanguage;

  /// Dropdown option for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Dropdown option for Spanish language
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLanguage;

  /// Section title for details of backends
  ///
  /// In en, this message translates to:
  /// **'Configure Backends & Endpoints'**
  String get backendsSection;

  /// Button label to cancel changes
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button label to save settings
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Toast message shown when settings are successfully saved
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccess;

  /// Warning card title when no chat backend is set
  ///
  /// In en, this message translates to:
  /// **'No Chat Connection Configured'**
  String get noChatConnectionTitle;

  /// Warning card description when no chat backend is set
  ///
  /// In en, this message translates to:
  /// **'To start using the chat interface and rendering Generative UI in real-time, please open settings and configure at least one of the execution modes:\n\n• Serverless: Enter a Gemini API Key to connect directly from the client.\n• Local Model: Provide a model path (e.g. gemma-2b-it.bin) for on-device inference.\n• Serverpod: Configure a remote Serverpod server URL.'**
  String get noChatConnectionDescription;

  /// Label for Serverless Gemini mode
  ///
  /// In en, this message translates to:
  /// **'Serverless Gemini'**
  String get serverlessGeminiLabel;

  /// Label for Local Gemma mode
  ///
  /// In en, this message translates to:
  /// **'Local Gemma'**
  String get localGemmaLabel;

  /// Label for Serverpod Remote mode
  ///
  /// In en, this message translates to:
  /// **'Serverpod Remote'**
  String get serverpodRemoteLabel;

  /// Short name for serverless mode
  ///
  /// In en, this message translates to:
  /// **'Serverless'**
  String get modeServerless;

  /// Short name for local mode
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get modeLocal;

  /// Short name for serverpod mode
  ///
  /// In en, this message translates to:
  /// **'Serverpod'**
  String get modeServerpod;

  /// Status bar label indicating the active execution mode
  ///
  /// In en, this message translates to:
  /// **'Active Mode'**
  String get activeModeStatusLabel;

  /// Button label to open connection settings dialog
  ///
  /// In en, this message translates to:
  /// **'OPEN SETTINGS'**
  String get openSettingsButton;

  /// Tooltip for the clear conversation button
  ///
  /// In en, this message translates to:
  /// **'Clear Conversation'**
  String get clearConversationTooltip;

  /// Label for Gemini API key input field
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key'**
  String get geminiApiKeyLabel;

  /// Error message when API key format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid Gemini API Key format'**
  String get invalidApiKeyFormat;

  /// Button label to paste key from clipboard
  ///
  /// In en, this message translates to:
  /// **'PASTE KEY'**
  String get pasteKeyButton;

  /// Button label to open external URL to obtain an API key
  ///
  /// In en, this message translates to:
  /// **'GET API KEY'**
  String get getApiKeyButton;

  /// Label for local model file path input
  ///
  /// In en, this message translates to:
  /// **'Model File Path (Assets/Storage)'**
  String get modelFilePathLabel;

  /// Label for serverpod server host endpoint URL input
  ///
  /// In en, this message translates to:
  /// **'Server Host endpoint URL'**
  String get serverHostUrlLabel;

  /// Label for temperature slider setting
  ///
  /// In en, this message translates to:
  /// **'Temperature:'**
  String get temperatureLabel;

  /// Button label to test active configuration connection
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnectionButton;

  /// Progress message showing connection test is active
  ///
  /// In en, this message translates to:
  /// **'Testing connection...'**
  String get testingConnectionProgress;

  /// Test result message when API key input is empty
  ///
  /// In en, this message translates to:
  /// **'API key cannot be empty.'**
  String get apiKeyCannotBeEmpty;

  /// Test result message when API key has invalid format
  ///
  /// In en, this message translates to:
  /// **'Invalid Gemini API key format.'**
  String get invalidApiKeyFormatMessage;

  /// Test result message when API key has valid format
  ///
  /// In en, this message translates to:
  /// **'API key format is valid! (Mock SSE ping passed)'**
  String get apiKeyFormatIsValid;

  /// Test result message when model path input is empty
  ///
  /// In en, this message translates to:
  /// **'Model path cannot be empty.'**
  String get modelPathCannotBeEmpty;

  /// Test result message when model path has valid format
  ///
  /// In en, this message translates to:
  /// **'Model file path format is valid! (Mock weight check passed)'**
  String get modelPathIsValid;

  /// Test result message when server URL input is empty
  ///
  /// In en, this message translates to:
  /// **'Server URL cannot be empty.'**
  String get serverUrlCannotBeEmpty;

  /// Test result message when serverpod connection succeeds
  ///
  /// In en, this message translates to:
  /// **'Serverpod host is reachable! (Mock WebSocket handshake passed)'**
  String get serverpodHostReachable;

  /// Snackbar warning message when clipboard has no text
  ///
  /// In en, this message translates to:
  /// **'No text found in clipboard'**
  String get noTextInClipboard;

  /// Subtitle for Serverless Gemini option
  ///
  /// In en, this message translates to:
  /// **'Direct SSE connection to Gemini API'**
  String get serverlessGeminiSubtitle;

  /// Subtitle for Local Gemma option
  ///
  /// In en, this message translates to:
  /// **'Native on-device LLM execution'**
  String get localGemmaSubtitle;

  /// Subtitle for Serverpod Remote option
  ///
  /// In en, this message translates to:
  /// **'WebSockets streaming via remote backend'**
  String get serverpodRemoteSubtitle;

  /// Label for active mode indicator badge
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get activeBadgeLabel;

  /// Header title of the component catalog sidebar panel
  ///
  /// In en, this message translates to:
  /// **'COMPONENTS'**
  String get componentsHeader;

  /// Label for hide/collapse action
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideLabel;

  /// Label for show/expand action
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showLabel;

  /// Display name of Custom Button component
  ///
  /// In en, this message translates to:
  /// **'Custom Button'**
  String get componentCustomButton;

  /// Display name of Task Item component
  ///
  /// In en, this message translates to:
  /// **'Task Item'**
  String get componentTaskItem;

  /// Display name of Stats Summary component
  ///
  /// In en, this message translates to:
  /// **'Stats Summary'**
  String get componentStatsSummary;

  /// Display name of User Card component
  ///
  /// In en, this message translates to:
  /// **'User Card'**
  String get componentUserCard;

  /// Display name of Metric Chart component
  ///
  /// In en, this message translates to:
  /// **'Metric Chart'**
  String get componentMetricChart;

  /// Display name of Priority Pill component
  ///
  /// In en, this message translates to:
  /// **'Priority Pill'**
  String get componentPriorityPill;

  /// Display name of Attachment List component
  ///
  /// In en, this message translates to:
  /// **'Attachment List'**
  String get componentAttachmentList;

  /// Display name of Single Attachment component
  ///
  /// In en, this message translates to:
  /// **'Single Attachment'**
  String get componentSingleAttachment;

  /// Display name of Quick Replies component
  ///
  /// In en, this message translates to:
  /// **'Quick Replies'**
  String get componentQuickReplies;

  /// Display name of Product Card component
  ///
  /// In en, this message translates to:
  /// **'Product Card'**
  String get componentProductCard;

  /// Display name of Timeline Log component
  ///
  /// In en, this message translates to:
  /// **'Timeline Log'**
  String get componentTimelineLog;

  /// Display name of Alert Banner component
  ///
  /// In en, this message translates to:
  /// **'Alert Banner'**
  String get componentAlertBanner;

  /// Snackbar message when custom button is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'CustomButton clicked! Label: \"{label}\"'**
  String catalogCustomButtonClicked(String label);

  /// Snackbar message when task checkbox is toggled in the catalog
  ///
  /// In en, this message translates to:
  /// **'TaskItemWidget checkbox toggled! Title: \"{title}\"'**
  String catalogTaskItemToggled(String title);

  /// Snackbar message when timeline event is tapped in the catalog
  ///
  /// In en, this message translates to:
  /// **'Timeline Event tapped: \"{eventTitle}\"'**
  String catalogTimelineEventTapped(String eventTitle);

  /// Snackbar message when attachment list item is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Attachment item clicked: \"{fileName}\"'**
  String catalogAttachmentItemClicked(String fileName);

  /// Snackbar message when alert banner action is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Alert Action clicked! Label: \"{actionLabel}\"'**
  String catalogAlertActionClicked(String actionLabel);

  /// Snackbar message when alert banner is dismissed in the catalog
  ///
  /// In en, this message translates to:
  /// **'Alert Banner dismissed!'**
  String get catalogAlertBannerDismissed;

  /// Snackbar message when single attachment is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Single Attachment tapped: \"{name}\"'**
  String catalogSingleAttachmentTapped(String name);

  /// Snackbar message when single attachment action is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Single Attachment action clicked! Status: {status}'**
  String catalogSingleAttachmentActionClicked(String status);

  /// Snackbar message when quick reply option is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Quick Reply selected: \"{reply}\"'**
  String catalogQuickReplySelected(String reply);

  /// Snackbar message when product card is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Product tapped: \"{title}\"'**
  String catalogProductTapped(String title);

  /// Snackbar message when product buy action is clicked in the catalog
  ///
  /// In en, this message translates to:
  /// **'Product bought! Price: {price}'**
  String catalogProductBought(String price);

  /// Badge label indicating component type in the catalog
  ///
  /// In en, this message translates to:
  /// **'A2UI Component'**
  String get catalogA2uiComponentBadge;

  /// Header title above live render preview
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get catalogPreviewHeader;

  /// Default label for Custom Button properties
  ///
  /// In en, this message translates to:
  /// **'Hello world'**
  String get btnLabelDefault;

  /// Default title for Task Item properties
  ///
  /// In en, this message translates to:
  /// **'Design Generative UI Architecture'**
  String get taskTitleDefault;

  /// Default label for Priority Pill properties
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get pillLabelDefault;

  /// Default title for Attachment List properties
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachmentTitleDefault;

  /// Default message text for Alert Banner properties
  ///
  /// In en, this message translates to:
  /// **'System memory is currently running high (85% utilization).'**
  String get alertMessageDefault;

  /// Default button label for Alert Banner properties
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get alertActionLabelDefault;

  /// Default title for Quick Replies properties
  ///
  /// In en, this message translates to:
  /// **'Select a follow-up action:'**
  String get quickRepliesTitleDefault;

  /// Default title for Product Card properties
  ///
  /// In en, this message translates to:
  /// **'Premium Wireless Headphones'**
  String get productTitleDefault;

  /// Default description for Product Card properties
  ///
  /// In en, this message translates to:
  /// **'High-fidelity audio with active noise cancellation and 40-hour battery life.'**
  String get productDescriptionDefault;

  /// Display name of project proposal pdf
  ///
  /// In en, this message translates to:
  /// **'Project Proposal.pdf'**
  String get projectProposalPdfName;

  /// Display name of design mockup png
  ///
  /// In en, this message translates to:
  /// **'Design Mockup.png'**
  String get designMockupPngName;

  /// Title of project initiated timeline event
  ///
  /// In en, this message translates to:
  /// **'Project Initiated'**
  String get projectInitiatedTitle;

  /// Description of project initiated timeline event
  ///
  /// In en, this message translates to:
  /// **'Kickoff meeting scheduled with client.'**
  String get projectInitiatedDesc;

  /// Title of design mockups timeline event
  ///
  /// In en, this message translates to:
  /// **'Design Mockups'**
  String get designMockupsTitle;

  /// Description of design mockups timeline event
  ///
  /// In en, this message translates to:
  /// **'Review visual layouts and typography guidelines.'**
  String get designMockupsDesc;

  /// Title of API integration timeline event
  ///
  /// In en, this message translates to:
  /// **'API Integration'**
  String get apiIntegrationTitle;

  /// Description of API integration timeline event
  ///
  /// In en, this message translates to:
  /// **'Connect UI surfaces to local and remote data handlers.'**
  String get apiIntegrationDesc;

  /// Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Quick reply option to view pricing
  ///
  /// In en, this message translates to:
  /// **'View pricing summary'**
  String get quickReplyViewPricing;

  /// Quick reply option to contact human
  ///
  /// In en, this message translates to:
  /// **'Contact human agent'**
  String get quickReplyContactHuman;

  /// Quick reply option to request custom proposal
  ///
  /// In en, this message translates to:
  /// **'Request custom proposal'**
  String get quickReplyRequestCustom;

  /// Default user name for User Card properties
  ///
  /// In en, this message translates to:
  /// **'Ada Lovelace'**
  String get userNameDefault;

  /// Default user role for User Card properties
  ///
  /// In en, this message translates to:
  /// **'Lead Architect'**
  String get userRoleDefault;

  /// Default metric title for Metric Chart properties
  ///
  /// In en, this message translates to:
  /// **'Project Completion'**
  String get metricTitleDefault;

  /// Default metric legend label for Metric Chart properties
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get metricLegendDefault;

  /// Default title for Timeline properties
  ///
  /// In en, this message translates to:
  /// **'Activity Timeline'**
  String get timelineTitleDefault;

  /// Default single attachment file name
  ///
  /// In en, this message translates to:
  /// **'Quarterly_Report_2026.pdf'**
  String get singleAttachmentNameDefault;

  /// Default single attachment file size
  ///
  /// In en, this message translates to:
  /// **'4.2 MB'**
  String get singleAttachmentSizeDefault;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
