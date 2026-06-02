# genui_annotations

The core annotations package for the GenUI ecosystem. 

This lightweight package provides the `@GenerativeUi` annotation, which is used to mark Flutter widgets for compile-time introspection. By keeping annotations separate from the builder logic, this package ensures your production code remains clean and free of heavy code-generation dependencies like `analyzer` or `build_runner`.

## 📦 Installation

Add `genui_annotations` to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations:
    path: ../genui_annotations # (Update this with the pub.dev version once published)
```

*Note: You will also need to add `genui_builder` and `build_runner` to your `dev_dependencies` to generate the code.*

## 🚀 Usage

Simply import the package and apply the `@GenerativeUi` annotation to any Flutter widget you want the local LLM to be able to render. You can optionally provide a custom name for the component using the `name` parameter.

```dart
import 'package:flutter/material.dart';
import 'package:genui_annotations/genui_annotations.dart';

part 'my_button.g.dart';

@GenerativeUi(name: 'CustomButton')
class MyButton extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const MyButton({
    super.key,
    required this.label,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Colors.grey,
      ),
      child: Text(label),
    );
  }
}
```

Once your widgets are annotated, run the build command from the root of your project or workspace to generate the static JSON schemas:

```bash
dart run build_runner build --delete-conflicting-outputs
```

*(If you are using the GenUI Melos workspace, you can simply run `melos run build_runner`)*

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

