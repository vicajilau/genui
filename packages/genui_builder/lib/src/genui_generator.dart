import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:genui_annotations/genui_annotations.dart';

/// Generator class for [GenerativeUI] annotations.
///
/// This class parses the unnamed constructor of annotated classes
/// to extract fields and types, generating a [CatalogItem] representation
/// that integrates directly with the official flutter/genui package.
class GenerativeUIGenerator extends GeneratorForAnnotation<GenerativeUI> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The @GenerativeUI annotation can only be applied to classes.',
        element: element,
      );
    }

    final className = element.name;
    if (className == null || className.isEmpty) {
      return '';
    }

    final customName = annotation.peek('name')?.stringValue;
    final componentName = customName ?? className;

    final constructor = element.unnamedConstructor;
    if (constructor == null) {
      throw InvalidGenerationSourceError(
        'The class $className must have an unnamed constructor to be generated.',
        element: element,
      );
    }

    final fieldsToProcess = <String, String>{}; // name -> Dart Type
    final callbackFields = <String>{};
    final requiredFields = <String>[];
    final defaultValues = <String, String>{};

    for (var parameter in constructor.formalParameters) {
      final name = parameter.name;
      if (name == null || name == 'key') continue;

      final typeStr = parameter.type.getDisplayString();
      final isCallback =
          typeStr == 'VoidCallback' ||
          typeStr.contains('Function') ||
          typeStr.endsWith('Callback') ||
          typeStr.startsWith('ValueChanged');

      if (isCallback) {
        callbackFields.add(name);
      } else {
        fieldsToProcess[name] = typeStr;
        if (parameter.isRequired) {
          requiredFields.add(name);
        }
        if (parameter.hasDefaultValue && parameter.defaultValueCode != null) {
          defaultValues[name] = parameter.defaultValueCode!;
        }
      }
    }

    final buffer = StringBuffer();

    buffer.writeln(
      '// ignore_for_file: type=lint, unused_element, unused_field, non_constant_identifier_names',
    );
    buffer.writeln('');

    // Generate the Identifier
    buffer.writeln('/// The mapped identifier for $className.');
    buffer.writeln('const String \$${className}Identifier = "$componentName";');
    buffer.writeln('');

    if (callbackFields.isNotEmpty) {
      buffer.writeln('/// Event name constants for $className.');
      buffer.writeln('abstract class ${className}Events {');
      for (final callback in callbackFields) {
        buffer.writeln(
          '  static const String $callback = \'${className}_${callback}Event\';',
        );
      }
      buffer.writeln('}');
      buffer.writeln('');
    }

    // Generate the CatalogItem compatible with package:genui
    buffer.writeln('/// Auto-generated CatalogItem for $className.');
    buffer.writeln(
      'final CatalogItem \$${className}CatalogItem = CatalogItem(',
    );
    buffer.writeln('  name: \$${className}Identifier,');
    buffer.writeln('  dataSchema: S.object(');
    buffer.writeln('    description: "Auto-generated schema for $className.",');
    buffer.writeln('    properties: {');

    fieldsToProcess.forEach((name, type) {
      String schemaMethod;
      switch (type) {
        case 'String':
          schemaMethod = 'S.string(description: "The $name property.")';
          break;
        case 'int':
          schemaMethod = 'S.integer(description: "The $name property.")';
          break;
        case 'double':
        case 'num':
          schemaMethod = 'S.number(description: "The $name property.")';
          break;
        case 'bool':
          schemaMethod = 'S.boolean(description: "The $name property.")';
          break;
        default:
          schemaMethod = 'S.string(description: "The $name property.")';
      }
      buffer.writeln('      "$name": $schemaMethod,');
    });

    buffer.writeln('    },');

    if (requiredFields.isNotEmpty) {
      final reqListStr = requiredFields.map((f) => '"$f"').join(', ');
      buffer.writeln('    required: [$reqListStr],');
    }

    buffer.writeln('  ),');

    // widgetBuilder implementation
    buffer.writeln('  widgetBuilder: (itemContext) {');
    buffer.writeln(
      '    final data = itemContext.data as Map<String, dynamic>;',
    );
    buffer.writeln('    return $className(');

    for (var parameter in constructor.formalParameters) {
      final name = parameter.name;
      if (name == null || name == 'key') continue;

      final typeStr = parameter.type.getDisplayString();
      final isNullable =
          parameter.type.nullabilitySuffix == NullabilitySuffix.question;

      final isCallback =
          typeStr == 'VoidCallback' ||
          typeStr.contains('Function') ||
          typeStr.endsWith('Callback') ||
          typeStr.startsWith('ValueChanged');

      if (isCallback) {
        final type = parameter.type;
        String paramList = '';
        String contextExtra = '';
        if (type is FunctionType) {
          final params = type.formalParameters;
          if (params.isNotEmpty) {
            final paramNames = <String>[];
            final paramDecls = <String>[];
            for (var i = 0; i < params.length; i++) {
              final p = params[i];
              final pName = (p.name ?? '').isNotEmpty ? p.name! : 'arg$i';
              paramNames.add(pName);
              paramDecls.add('${p.type.getDisplayString()} $pName');
            }
            paramList = paramDecls.join(', ');
            final extraEntries = paramNames.map((n) => "'$n': $n").join(', ');
            contextExtra = ', ...{$extraEntries}';
          }
        }

        buffer.writeln('      $name: ($paramList) {');
        buffer.writeln('        itemContext.dispatchEvent(');
        buffer.writeln('          UserActionEvent(');
        buffer.writeln('            name: ${className}Events.$name,');
        buffer.writeln('            sourceComponentId: itemContext.id,');
        buffer.writeln('            context: {');
        buffer.writeln('              ...data$contextExtra');
        buffer.writeln('            },');
        buffer.writeln('          ),');
        buffer.writeln('        );');
        buffer.writeln('      },');
      } else {
        if (parameter.isRequired) {
          buffer.writeln('      $name: data["$name"] as $typeStr,');
        } else {
          if (isNullable) {
            buffer.writeln('      $name: data["$name"] as $typeStr?,');
          } else {
            var fallback = 'null';
            if (typeStr == 'bool') fallback = 'false';
            if (typeStr == 'int') fallback = '0';
            if (typeStr == 'double') fallback = '0.0';
            if (typeStr == 'String') fallback = '""';

            final defVal = defaultValues[name] ?? fallback;
            buffer.writeln(
              '      $name: (data["$name"] as $typeStr?) ?? $defVal,',
            );
          }
        }
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  },');
    buffer.writeln(');');

    return buffer.toString();
  }
}
