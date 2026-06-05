import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:dart_style/dart_style.dart';

/// A global Builder that scans the ORIGINAL source files, finds the annotations,
/// and predicts the generated paths to assemble the central Catalog.
class GenUIRegistryBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
    r'$lib$': ['genui_registry.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    print(
      '--- [GenUI] Global Registry Builder is scanning source files for CatalogItems... ---',
    );

    final exports = <String>{};
    final mapEntries = <String>[];

    // 1. Scan ALL original .dart files in the lib folder.
    final glob = Glob('lib/**.dart');
    final assets = await buildStep.findAssets(glob).toList();

    for (final asset in assets) {
      if (asset.path.endsWith('.g.dart')) continue;

      final content = await buildStep.readAsString(asset);

      if (!content.contains('@generativeUI') &&
          !content.contains('@GenerativeUI')) {
        continue;
      }

      // Find the `@generativeUI` or `@GenerativeUI` annotation and capture the class name.
      final regex = RegExp(
        r'@(?:generativeUI|GenerativeUI)[^\{;]*?class\s+([a-zA-Z0-9_]+)',
      );
      final matches = regex.allMatches(content);

      if (matches.isNotEmpty) {
        final originalPath = asset.uri.toString();
        exports.add("import '$originalPath';");

        for (final match in matches) {
          final className = match.group(1);
          if (className != null) {
            mapEntries.add('  \$${className}CatalogItem,');
          }
        }
      }
    }

    if (mapEntries.isEmpty) return;

    // 5. Build the final registry string.
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// ignore_for_file: type=lint, unused_import');
    buffer.writeln('');
    buffer.writeln("import 'dart:convert';");
    buffer.writeln("import 'package:genui/genui.dart';");
    buffer.writeln(
      "import 'package:json_schema_builder/json_schema_builder.dart';",
    );
    buffer.writeln('');

    for (final export in exports) {
      buffer.writeln(export);
    }

    buffer.writeln('');
    buffer.writeln(
      '/// Global list of all auto-generated Generative UI CatalogItems.',
    );
    buffer.writeln('final List<CatalogItem> generatedCatalogItems = [');

    for (final entry in mapEntries) {
      buffer.writeln(entry);
    }

    buffer.writeln('];');
    buffer.writeln('');
    buffer.writeln(
      '/// Global catalog composed of all auto-generated catalog items combined with the official basic catalog.',
    );
    buffer.writeln('final Catalog globalGenUICatalog = Catalog(');
    buffer.writeln('  [');
    buffer.writeln('    ...BasicCatalogItems.asCatalog().items,');
    buffer.writeln('    ...generatedCatalogItems,');
    buffer.writeln('  ],');
    buffer.writeln("  catalogId: 'inline_catalog',");
    buffer.writeln(');');
    buffer.writeln('');
    buffer.writeln('/// Exported JSON Schema map of all custom components.');
    buffer.writeln(
      'Map<String, Map<String, dynamic>> get globalGenUISchemas => {',
    );
    buffer.writeln('  for (final item in generatedCatalogItems)');
    buffer.writeln(
      '    item.name: jsonDecode(item.dataSchema.toJson()) as Map<String, dynamic>,',
    );
    buffer.writeln('};');
    buffer.writeln('');
    buffer.writeln(
      '/// JSON-encoded string of the schemas for local/in-memory use.',
    );
    buffer.writeln(
      'String get globalGenUISchemasJson => jsonEncode(globalGenUISchemas);',
    );
    buffer.writeln('');
    buffer.writeln(
      '/// A pre-formatted prompt description listing all component schemas for LLM system instructions.',
    );
    buffer.writeln('String get globalGenUISchemasPromptDescription {');
    buffer.writeln('  final buffer = StringBuffer();');
    buffer.writeln('  globalGenUISchemas.forEach((name, schema) {');
    buffer.writeln('    buffer.writeln(\'- Component: "\$name"\');');
    buffer.writeln('    buffer.writeln(\'  Schema: \${jsonEncode(schema)}\');');
    buffer.writeln('  });');
    buffer.writeln('  return buffer.toString();');
    buffer.writeln('}');

    final outputAsset = AssetId(
      buildStep.inputId.package,
      'lib/genui_registry.g.dart',
    );

    try {
      final formattedCode = DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(buffer.toString());
      await buildStep.writeAsString(outputAsset, formattedCode);
    } catch (e) {
      await buildStep.writeAsString(outputAsset, buffer.toString());
      print('--- [GenUI] Warning: Could not format generated registry: $e ---');
    }

    print(
      '--- [GenUI] Registry successfully assembled with ${mapEntries.length} CatalogItems! ---',
    );
  }
}
