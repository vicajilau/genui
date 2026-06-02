import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/genui_generator.dart';
import 'src/registry_builder.dart'; // <-- Importamos el nuevo builder

/// Phase 1: Local Engine (Generates the .genui.g.dart files)
Builder genuiBuilder(BuilderOptions options) => PartBuilder(
      [GenerativeUIGenerator()],
      '.genui.g.dart',
    );

/// Phase 2: Global Engine (Generates the genui_registry.g.dart index)
Builder genuiRegistryBuilder(BuilderOptions options) => GenUIRegistryBuilder();