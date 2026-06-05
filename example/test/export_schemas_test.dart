// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/genui_registry.g.dart';

void main() {
  test('Export GenUI schemas to JSON', () {
    print('--- [GenUI Exporter] Exporting component schemas to JSON... ---');
    try {
      final schemas = globalGenUISchemas;
      final jsonString = const JsonEncoder.withIndent('  ').convert(schemas);

      // Determine output path based on environment variable or current working directory
      final envPath = Platform.environment['GENUI_EXPORT_PATH'];
      final File file;
      if (envPath != null && envPath.isNotEmpty) {
        file = File(envPath);
      } else {
        final currentDir = Directory.current.path;
        if (File('$currentDir/pubspec.yaml').existsSync() &&
            !Directory('$currentDir/example').existsSync()) {
          // We are inside the 'example' package directory
          file = File('build/genui_schemas.json');
        } else {
          // We are at the workspace root
          file = File('example/build/genui_schemas.json');
        }
      }

      file.parent.createSync(recursive: true);
      file.writeAsStringSync(jsonString);

      print(
        '✓ [GenUI Exporter] Schemas successfully written to: ${file.absolute.path}',
      );
    } catch (e, stackTrace) {
      print('✗ [GenUI Exporter] Error exporting schemas: $e');
      print(stackTrace);
      fail('Failed to export schemas: $e');
    }
  });
}
