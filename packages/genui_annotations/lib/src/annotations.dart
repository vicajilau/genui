/// Annotation to register a Widget in the Generative UI catalog.
/// It requires zero configuration by default.
class GenerativeUI {
  /// Optional custom name for the component to override the class name.
  final String? name;

  const GenerativeUI({this.name});
}

/// A default instance for the annotation to be used as `@generativeUI`.
const generativeUI = GenerativeUI();
