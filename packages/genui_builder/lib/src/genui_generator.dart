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
    // Read the format from the annotation (defaults to 'flat')
    final formatField = annotation.peek('format');
    // Extract the enum accessor name, e.g. 'SchemaFormat.a2ui' or 'SchemaFormat.flat'
    final formatName = formatField?.revive().accessor ?? 'flat';

    buffer.writeln('/// Auto-generated JSON Schema representation for $className.');
    buffer.writeln('const Map<String, dynamic> \$${className}Schema = {');

    final fieldsToProcess = <String, String>{};

    // 5. Iterate through all fields in the AST class element to populate fieldsToProcess.
    for (var field in element.fields) {
      if (field.isPrivate || field.isStatic) continue;
      final fieldName = field.name;
      if (fieldName == null || fieldName.isEmpty) continue;
      final fieldType = field.type.getDisplayString();
      fieldsToProcess[fieldName] = fieldType;
    }

    if (formatName.endsWith('a2ui')) {
      buffer.writeln('  "component": "$componentName",');
      buffer.writeln('  "props": {');
      fieldsToProcess.forEach((name, type) {
        buffer.writeln('    "$name": "$type",');
      });
      buffer.writeln('  }');
    } else {
      buffer.writeln('  "type": "$componentName",');
      buffer.writeln('  "properties": {');
      fieldsToProcess.forEach((name, type) {
        buffer.writeln('    "$name": "$type",');
      });
      buffer.writeln('  }');
    }

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