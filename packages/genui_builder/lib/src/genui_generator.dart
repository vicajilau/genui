import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:genui_annotations/genui_annotations.dart';

/// Generator class for [GenerativeUi] annotations.
///
/// This class parses the Abstract Syntax Tree (AST) of annotated classes
/// to extract their fields and types, generating a static JSON schema
/// representation that can be fed into a local LLM's system prompt.
class GenerativeUiGenerator extends GeneratorForAnnotation<GenerativeUi> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // 1. Ensure the annotation is strictly applied to a class.
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The @GenerativeUi annotation can only be applied to classes.',
        element: element,
      );
    }

    // 2. Extract the component name.
    // Uses the custom name from the annotation if provided, otherwise defaults to the Dart class name.
    final customName = annotation.peek('name')?.stringValue;
    final className = element.name;
    final componentName = customName ?? className;

    final buffer = StringBuffer();
    buffer.writeln(
      '/// Auto-generated JSON Schema representation for $className.',
    );
    buffer.writeln('const Map<String, dynamic> _\$${className}Schema = {');
    buffer.writeln('  "type": "$componentName",');
    buffer.writeln('  "properties": {');

    // 3. Iterate through all fields in the AST class element.
    for (var field in element.fields) {
      // Ignore private or static properties as they are not part of the widget's public API.
      if (field.isPrivate || field.isStatic) continue;

      final fieldName = field.name;
      // Extract the string representation of the Dart type (e.g., "String", "bool").
      final fieldType = field.type.getDisplayString();

      buffer.writeln('    "$fieldName": "$fieldType",');
    }

    buffer.writeln('  }');
    buffer.writeln('};');

    return buffer.toString();
  }
}
