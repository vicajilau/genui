import 'package:genui_annotations/genui_annotations.dart';

/// Annotation to register a Widget in the Generative UI catalog.
/// It requires zero configuration by default.
class GenerativeUI {
  /// The structural format of the generated schema.
  /// Defaults to [SchemaFormat.flat].
  final SchemaFormat format;

  const GenerativeUI({this.format = SchemaFormat.flat});
}

/// A default instance for the annotation to be used as `@generativeUI`.
const generativeUI = GenerativeUI();
