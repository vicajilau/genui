import 'dart:ui';
import 'package:intl/intl.dart';

/// Handles localization of messages and date formats for the GenUI chat interface.
/// Automatically handles formatting and translations using the `intl` package.
class ChatLocalization {
  final String languageCode;

  ChatLocalization(this.languageCode);

  factory ChatLocalization.fromLocale(Locale locale) {
    return ChatLocalization(locale.languageCode.toLowerCase());
  }

  /// Map of English language names for LLM prompt context.
  static const Map<String, String> _languageNames = {
    'es': 'Spanish',
    'en': 'English',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'nl': 'Dutch',
    'ru': 'Russian',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'tr': 'Turkish',
    'sv': 'Swedish',
    'no': 'Norwegian',
    'da': 'Danish',
    'fi': 'Finnish',
  };

  /// Returns the language name in English (e.g. "Spanish"), defaulting to "English" if not in the map.
  String get languageName => _languageNames[languageCode] ?? 'English';

  /// Localized greeting message based on active persona.
  String getGreeting() {
    switch (languageCode) {
      case 'es':
        return '¡Hola! Soy tu asistente virtual de atención al cliente.\n\n'
            'Estoy aquí para ayudarte a gestionar tus servicios. Puedes pedirme cosas como:\n'
            '• "Ver mis facturas"\n'
            '• "Pedir mi certificado de retenciones de 2025"\n'
            '• "Pagar factura pendiente"\n'
            '• "Ver mi perfil de usuario"\n\n'
            '¿En qué te puedo colaborar hoy?';
      case 'fr':
        return 'Bonjour ! Je suis votre assistant virtuel de service client.\n\n'
            'Je suis là pour vous aider à gérer vos services. Vous pouvez me demander :\n'
            '• "Voir mes factures"\n'
            '• "Demander mon certificat de retenues à la source 2025"\n'
            '• "Payer une facture en attente"\n'
            '• "Voir mon profil utilisateur"\n\n'
            'Comment puis-je vous aider aujourd’hui ?';
      case 'de':
        return 'Hallo! Ich bin Ihr virtueller Kundenservice-Assistent.\n\n'
            'Ich bin hier, um Ihnen bei der Verwaltung Ihrer Dienste zu helfen. Sie können mich folgendes fragen:\n'
            '• "Meine Rechnungen anzeigen"\n'
            '• "Meinen Steuerabzugsbeleg für 2025 anfordern"\n'
            '• "Ausstehende Rechnung bezahlen"\n'
            '• "Mein Benutzerprofil anzeigen"\n\n'
            'Wie kann ich Ihnen heute helfen?';
      case 'it':
        return 'Ciao! Sono il tuo assistente virtuale del servizio clienti.\n\n'
            'Sono qui per aiutarti a gestire i tuoi servizi. Puoi chiedermi cose come:\n'
            '• "Mostra le mie fatture"\n'
            '• "Richiedi il mio certificato di ritenuta d’acconto 2025"\n'
            '• "Paga fattura in sospeso"\n'
            '• "Visualizza il mio profilo utente"\n\n'
            'Come posso aiutarti oggi?';
      case 'pt':
        return 'Olá! Sou o seu assistente virtual de atendimento ao cliente.\n\n'
            'Estou aqui para ajudar a gerir os seus serviços. Pode pedir-me coisas como:\n'
            '• "Ver as minhas faturas"\n'
            '• "Solicitar o meu comprovativo de retenções de 2025"\n'
            '• "Pagar fatura pendente"\n'
            '• "Ver o meu perfil de utilizador"\n\n'
            'Como posso ajudar hoje?';
      default:
        return 'Hello! I am your virtual customer service assistant.\n\n'
            'I am here to help you manage your services. You can ask me things like:\n'
            '• "Show my invoices"\n'
            '• "Request my 2025 tax withholding certificate"\n'
            '• "Pay pending invoice"\n'
            '• "View my user profile"\n\n'
            'How can I help you today?';
    }
  }

  /// Formatted date in the correct locale conventions.
  String getFormattedDate(DateTime date) {
    try {
      return DateFormat.yMMMMd(languageCode).format(date);
    } catch (_) {
      // Fallback if locale formatting fails or isn't fully initialized
      return DateFormat.yMMMMd('en').format(date);
    }
  }

  /// Translated month name for prompt context.
  String getMonthName(DateTime date) {
    try {
      return DateFormat.LLLL(languageCode).format(date);
    } catch (_) {
      return DateFormat.LLLL('en').format(date);
    }
  }
}
