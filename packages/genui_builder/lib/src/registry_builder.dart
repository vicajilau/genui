import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:dart_style/dart_style.dart';

/// A global Builder that scans the ORIGINAL source files, finds the annotations,
/// and predicts the generated paths to assemble the central registry.
class GenUIRegistryBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
    r'$lib$': ['genui_registry.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    print(
      '--- [GenUI] Global Registry Builder is scanning source files... ---',
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

      // 2. Regex: Find the `@generativeUI` or `@GenerativeUI` annotation and capture the class name.
      // We restrict the intermediate characters `[^\{;]*?` to prevent matching across
      // statements or block boundaries. This avoids false positives if the annotation
      // text appears inside a comment or string.
      final regex = RegExp(
        r'@(?:generativeUI|GenerativeUI)[^\{;]*?class\s+([a-zA-Z0-9_]+)',
      );
      final matches = regex.allMatches(content);

      if (matches.isNotEmpty) {
        // 3. Import the ORIGINAL file, not the generated part file!
        // The original file exposes its generated parts automatically.
        final originalPath = asset.uri.toString();
        exports.add("import '$originalPath';");

        // 4. Assemble the exact variables we know Phase 1 will generate.
        for (final match in matches) {
          final className = match.group(1);
          if (className != null) {
            // We use a multiline string so each component is exactly ONE element in the list.
            mapEntries.add('''
  \$${className}Identifier: (
    fromJson: (json) => \$${className}FromJson(json),
    schema: \$${className}Schema,
  ),''');
          }
        }
      }
    }

    if (mapEntries.isEmpty) return;

    // 5. Build the final registry string.
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln('');

    for (final export in exports) {
      buffer.writeln(export);
    }

    buffer.writeln('');
    buffer.writeln(
      '/// Global registry of all annotated Generative UI components.',
    );
    buffer.writeln(
      '/// Contains both the instantiator function and the JSON schema for the LLM prompt.',
    );
    buffer.writeln(
      'final Map<String, ({dynamic Function(Map<String, dynamic>) fromJson, Map<String, dynamic> schema})> globalGenUIRegistry = {',
    );

    for (final entry in mapEntries) {
      buffer.writeln(entry);
    }

    buffer.writeln('};');

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
      // Fallback in case of syntax error in the generated string
      await buildStep.writeAsString(outputAsset, buffer.toString());
      print('--- [GenUI] Warning: Could not format generated registry: $e ---');
    }

    print(
      '--- [GenUI] Registry successfully assembled with ${mapEntries.length} components! ---',
    );
  }
}
