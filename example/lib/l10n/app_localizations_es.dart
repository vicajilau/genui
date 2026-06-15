// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String downloadingFile(String fileName) {
    return 'Descargando \"$fileName\"...';
  }

  @override
  String downloadSuccess(String fileName) {
    return '¡\"$fileName\" descargado con éxito!';
  }

  @override
  String get defaultFileName => 'archivo';

  @override
  String get alertDismissedLocally => 'Alerta descartada localmente.';

  @override
  String actionExecuted(String actionLabel) {
    return 'Acción ejecutada: \"$actionLabel\"';
  }

  @override
  String get defaultActionLabel => 'Acción';

  @override
  String timelineStatusUpdated(String eventTitle) {
    return 'Estado de \"$eventTitle\" actualizado.';
  }

  @override
  String get processingSecurePayment => 'Procesando pago seguro...';

  @override
  String get paymentSuccessful =>
      '¡Pago realizado con éxito! Tu factura ha sido liquidada.';

  @override
  String buttonPressed(String label) {
    return 'Botón presionado: \"$label\"';
  }

  @override
  String get defaultButtonLabel => 'Botón';

  @override
  String get appTitle => 'GenUI Playground';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get componentCatalogTab => 'Catálogo de Componentes';

  @override
  String get aiChatTab => 'Chat de IA';

  @override
  String get geminiChatTab => 'Chat de Gemini AI';

  @override
  String get localGemmaChatTab => 'Chat de Gemma Local';

  @override
  String get serverpodChatTab => 'Chat de Serverpod';

  @override
  String get defaultChatHint => 'Pídele al modelo que cree widgets...';

  @override
  String get geminiChatHint => 'Pídele a Gemini que cree widgets...';

  @override
  String get localGemmaChatHint => 'Pídele a Gemma que cree widgets...';

  @override
  String get serverpodChatHint => 'Pídele a Serverpod que cree widgets...';

  @override
  String get connectionError => 'Error de Conexión';

  @override
  String get networkRequestFailed => 'La solicitud de red ha fallado.';

  @override
  String get retry => 'Reintentar';

  @override
  String get settingsTitle => 'Ajustes de Conexión';

  @override
  String get activeChatModeLabel => 'Modo de Ejecución de Chat Activo';

  @override
  String get appPersonaLabel => 'Contexto / Rol de Aplicación';

  @override
  String get taskBoardPersona => 'Tablero de Tareas';

  @override
  String get customerAppPersona => 'App de Clientes';

  @override
  String get selectAppLanguage => 'Idioma de la Aplicación';

  @override
  String get systemLanguage => 'Predeterminado del Sistema';

  @override
  String get englishLanguage => 'Inglés';

  @override
  String get spanishLanguage => 'Español';

  @override
  String get backendsSection => 'Configurar Backends y Endpoints';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get settingsSavedSuccess => '¡Ajustes guardados con éxito!';

  @override
  String get noChatConnectionTitle => 'Sin conexión de chat configurada';

  @override
  String get noChatConnectionDescription =>
      'Para comenzar a usar la interfaz de chat y renderizar Generative UI en tiempo real, abra la configuración y configure al menos uno de los modos de ejecución:\n\n• Serverless: Ingrese una clave API de Gemini para conectarse directamente desde el cliente.\n• Modelo local: Proporcione una ruta de modelo (ej. gemma-2b-it.bin) para inferencia en el dispositivo.\n• Serverpod: Configure una URL remota de servidor Serverpod.';

  @override
  String get serverlessGeminiLabel => 'Gemini sin servidor';

  @override
  String get localGemmaLabel => 'Gemma local';

  @override
  String get serverpodRemoteLabel => 'Serverpod remoto';

  @override
  String get modeServerless => 'Sin servidor';

  @override
  String get modeLocal => 'Local';

  @override
  String get modeServerpod => 'Serverpod';

  @override
  String get activeModeStatusLabel => 'Modo activo';

  @override
  String get openSettingsButton => 'ABRIR CONFIGURACIÓN';

  @override
  String get clearConversationTooltip => 'Limpiar conversación';

  @override
  String get geminiApiKeyLabel => 'Clave API de Gemini';

  @override
  String get invalidApiKeyFormat => 'Formato de clave API de Gemini no válido';

  @override
  String get pasteKeyButton => 'PEGAR CLAVE';

  @override
  String get getApiKeyButton => 'OBTENER CLAVE';

  @override
  String get modelFilePathLabel =>
      'Ruta del archivo de modelo (Assets/Almacenamiento)';

  @override
  String get serverHostUrlLabel => 'URL del host del servidor';

  @override
  String get temperatureLabel => 'Temperatura:';

  @override
  String get testConnectionButton => 'Probar conexión';

  @override
  String get testingConnectionProgress => 'Probando conexión...';

  @override
  String get apiKeyCannotBeEmpty => 'La clave API no puede estar vacía.';

  @override
  String get invalidApiKeyFormatMessage =>
      'Formato de clave API de Gemini no válido.';

  @override
  String get apiKeyFormatIsValid =>
      '¡El formato de la clave API es válido! (Ping SSE simulado superado)';

  @override
  String get modelPathCannotBeEmpty =>
      'La ruta del modelo no puede estar vacía.';

  @override
  String get modelPathIsValid =>
      '¡El formato de la ruta del archivo de modelo es válido! (Verificación de pesos simulada superada)';

  @override
  String get serverUrlCannotBeEmpty =>
      'La URL del servidor no puede estar vacía.';

  @override
  String get serverpodHostReachable =>
      '¡El host de Serverpod es accesible! (Handshake WebSocket simulado superado)';

  @override
  String get noTextInClipboard => 'No se encontró texto en el portapapeles';

  @override
  String get serverlessGeminiSubtitle =>
      'Conexión SSE directa a la API de Gemini';

  @override
  String get localGemmaSubtitle => 'Ejecución nativa de LLM en el dispositivo';

  @override
  String get serverpodRemoteSubtitle =>
      'Transmisión de WebSockets a través de backend remoto';

  @override
  String get activeBadgeLabel => 'ACTIVO';

  @override
  String get componentsHeader => 'COMPONENTES';

  @override
  String get hideLabel => 'Ocultar';

  @override
  String get showLabel => 'Mostrar';

  @override
  String get componentCustomButton => 'Botón personalizado';

  @override
  String get componentTaskItem => 'Tarea de la lista';

  @override
  String get componentStatsSummary => 'Resumen de estadísticas';

  @override
  String get componentUserCard => 'Tarjeta de usuario';

  @override
  String get componentMetricChart => 'Gráfico de métricas';

  @override
  String get componentPriorityPill => 'Píldora de prioridad';

  @override
  String get componentAttachmentList => 'Lista de adjuntos';

  @override
  String get componentSingleAttachment => 'Adjunto único';

  @override
  String get componentQuickReplies => 'Respuestas rápidas';

  @override
  String get componentProductCard => 'Tarjeta de producto';

  @override
  String get componentTimelineLog => 'Línea de tiempo';

  @override
  String get componentAlertBanner => 'Banner de alerta';

  @override
  String catalogCustomButtonClicked(String label) {
    return '¡CustomButton presionado! Etiqueta: \"$label\"';
  }

  @override
  String catalogTaskItemToggled(String title) {
    return '¡Checkbox de TaskItemWidget cambiado! Título: \"$title\"';
  }

  @override
  String catalogTimelineEventTapped(String eventTitle) {
    return '¡Evento de línea de tiempo pulsado: \"$eventTitle\"';
  }

  @override
  String catalogAttachmentItemClicked(String fileName) {
    return '¡Elemento adjunto pulsado: \"$fileName\"';
  }

  @override
  String catalogAlertActionClicked(String actionLabel) {
    return '¡Acción de alerta pulsada! Etiqueta: \"$actionLabel\"';
  }

  @override
  String get catalogAlertBannerDismissed => '¡Banner de alerta descartado!';

  @override
  String catalogSingleAttachmentTapped(String name) {
    return '¡Adjunto único pulsado: \"$name\"';
  }

  @override
  String catalogSingleAttachmentActionClicked(String status) {
    return '¡Acción de adjunto único pulsada! Estado: $status';
  }

  @override
  String catalogQuickReplySelected(String reply) {
    return '¡Respuesta rápida seleccionada: \"$reply\"';
  }

  @override
  String catalogProductTapped(String title) {
    return '¡Producto pulsado: \"$title\"';
  }

  @override
  String catalogProductBought(String price) {
    return '¡Producto comprado! Precio: $price';
  }

  @override
  String get catalogA2uiComponentBadge => 'Componente A2UI';

  @override
  String get catalogPreviewHeader => 'VISTA PREVIA';

  @override
  String get btnLabelDefault => 'Hola mundo';

  @override
  String get taskTitleDefault => 'Diseñar arquitectura de Generative UI';

  @override
  String get pillLabelDefault => 'Prioridad alta';

  @override
  String get attachmentTitleDefault => 'Archivos adjuntos';

  @override
  String get alertMessageDefault =>
      'La memoria del sistema se está agotando (85% de utilización).';

  @override
  String get alertActionLabelDefault => 'Resolver';

  @override
  String get quickRepliesTitleDefault =>
      'Seleccione una acción de seguimiento:';

  @override
  String get productTitleDefault => 'Auriculares inalámbricos premium';

  @override
  String get productDescriptionDefault =>
      'Audio de alta fidelidad con cancelación activa de ruido y 40 horas de duración de la batería.';

  @override
  String get projectProposalPdfName => 'Propuesta de Proyecto.pdf';

  @override
  String get designMockupPngName => 'Boceto de Diseño.png';

  @override
  String get projectInitiatedTitle => 'Proyecto Iniciado';

  @override
  String get projectInitiatedDesc =>
      'Reunión de inicio programada con el cliente.';

  @override
  String get designMockupsTitle => 'Bocetos de Diseño';

  @override
  String get designMockupsDesc =>
      'Revisar diseños visuales y directrices tipográficas.';

  @override
  String get apiIntegrationTitle => 'Integración de la API';

  @override
  String get apiIntegrationDesc =>
      'Conectar superficies de interfaz de usuario a controladores de datos locales y remotos.';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get thursday => 'Jueves';

  @override
  String get quickReplyViewPricing => 'Ver resumen de precios';

  @override
  String get quickReplyContactHuman => 'Contactar con agente humano';

  @override
  String get quickReplyRequestCustom => 'Solicitar propuesta personalizada';

  @override
  String get userNameDefault => 'Ada Lovelace';

  @override
  String get userRoleDefault => 'Arquitecta Principal';

  @override
  String get metricTitleDefault => 'Progreso del Proyecto';

  @override
  String get metricLegendDefault => 'Completado';

  @override
  String get timelineTitleDefault => 'Línea de tiempo de actividad';

  @override
  String get singleAttachmentNameDefault => 'Informe_Trimestral_2026.pdf';

  @override
  String get singleAttachmentSizeDefault => '4.2 MB';
}
