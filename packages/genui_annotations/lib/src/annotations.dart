/// Annotation to mark a Widget that will be exported to the local LLM.
/// The genui_builder package will generate a static JSON schema for the component.
class GenerativeUI {
  /// Optional name for the component. If null, the generator 
  /// will use the name of the Dart class.
  final String? name;

  const GenerativeUI({this.name});
}

const generativeUI = GenerativeUI();