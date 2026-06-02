import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/genui_generator.dart';

/// Factory function to initialize the [GenerativeUIGenerator].
Builder genuiBuilder(BuilderOptions options) => PartBuilder(
      [GenerativeUIGenerator()],
      '.genui.g.dart',
    );