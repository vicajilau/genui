import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/genui_generator.dart';

/// Factory function to initialize the [GenerativeUiGenerator].
///
/// This builder generates `.genui.g.dart` files containing the extracted
/// component schemas based on the classes annotated with [GenerativeUi].
Builder genuiBuilder(BuilderOptions options) => SharedPartBuilder(
      [GenerativeUiGenerator()],
      'genui',
    );