import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:genui_annotations/genui_annotations.dart';

/// Generator class for [GenerativeUI] annotations.
///
/// This class parses the Abstract Syntax Tree (AST) of annotated classes
/// to extract their fields and types, generating a static JSON schema
/// representation that can be fed into a local LLM's system prompt.
class GenerativeUIGenerator extends GeneratorForAnnotation<GenerativeUI> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // 1. Ensure the annotation is strictly applied to a class.
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The @GenerativeUI annotation can only be applied to classes.',
        element: element,
      );
    }

    // Extract the Dart class name. Add a null safety check just in case.
    final className = element.name;
    if (className == null || className.isEmpty) {
      return '';
    }

    // 2. Extract the component name.
    // Uses the custom name from the annotation if provided, otherwise defaults to the Dart class name.
    final customName = annotation.peek('name')?.stringValue;
    final componentName = customName ?? className;

    final buffer = StringBuffer();

    // --- SILENCE THE LINTER ---
    // This prevents warnings in the auto-generated files.
    buffer.writeln('// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names');
    buffer.writeln('');

    // 3. GENERATE THE IDENTIFIER (Public: starts with $)
    buffer.writeln('/// The mapped identifier for $className.');
    buffer.writeln('const String \$${className}Identifier = "$componentName";');
    buffer.writeln('');

    // 4. GENERATE THE SCHEMA (Public)
    buffer.writeln('/// Auto-generated JSON Schema representation for $className.');
    buffer.writeln('const Map<String, dynamic> \$${className}Schema = {');
    buffer.writeln('  "type": "$componentName",');
    buffer.writeln('  "properties": {');

    final fieldsToProcess = <String, String>{};

    // 5. Iterate through all fields in the AST class element.
    for (var field in element.fields) {
      // Ignore private or static properties as they are not part of the widget's public API.
      if (field.isPrivate || field.isStatic) continue;

      final fieldName = field.name;
      
      // Null safety check: If the AST detects an unnamed element, ignore it.
      if (fieldName == null || fieldName.isEmpty) continue;

      // Extract the string representation of the Dart type (e.g., "String", "bool").
      final fieldType = field.type.getDisplayString();
      
      fieldsToProcess[fieldName] = fieldType;

      buffer.writeln('    "$fieldName": "$fieldType",');
    }

    buffer.writeln('  }');
    buffer.writeln('};');
    buffer.writeln('');

    // 6. GENERATE THE INSTANTIATOR FUNCTION (Public)
    buffer.writeln('/// Factory function to instantiate $className from a JSON map.');
    buffer.writeln('$className \$${className}FromJson(Map<String, dynamic> json) {');
    buffer.writeln('  return $className(');

    fieldsToProcess.forEach((name, type) {
      buffer.writeln('    $name: json["$name"] as $type,');
    });

    buffer.writeln('  );');
    buffer.writeln('}');

    return buffer.toString();
  }
}