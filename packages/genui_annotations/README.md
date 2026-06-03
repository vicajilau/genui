# genui_annotations

The core annotations package for the GenUI code generation ecosystem.

This lightweight package provides the `@generativeUI` and `@GenerativeUI` annotations, which are used to mark Flutter widgets for compile-time introspection. By keeping annotations separate from the builder logic, this package ensures your production code remains clean and free of heavy code-generation dependencies like `analyzer` or `build_runner`.

---

## 📦 Installation

Add `genui_annotations` to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations: any # (Resolved via Dart Workspaces or pub.dev)
```

*Note: You will also need to add `genui_builder` and `build_runner` to your `dev_dependencies` to generate the code.*

---

## 🚀 Usage

Simply import the package and apply the `@generativeUI` annotation to any Flutter widget you want to expose to the GenUI AI Catalog.

```dart
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_annotations/genui_annotations.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

// The part directive must match the file name exactly with the .genui.g.dart extension
part 'my_button.genui.g.dart';

@generativeUI
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
      child: Text(label),
    );
  }
}
```

### Customizing the Component Name

By default, the generator uses the exact class name in Dart (e.g. `MyButton`) as the component name in the JSON schema. If you want to decouple the Dart class name from the JSON protocol contract (e.g. using shorter or language-independent names for the LLM), you can pass a custom `name`:

```dart
@GenerativeUI(name: 'PrimaryActionButton')
class MyButton extends StatelessWidget {
  // ...
}
```

This will register the component as `PrimaryActionButton` in the schema and the catalog registry, while your Flutter code keeps using `MyButton`.

---

## ⚙️ Code Generation

Once your widgets are annotated, run the build command to generate the static `CatalogItem` definitions and the central `Catalog` file:

```bash
dart run build_runner build
```

*(If you are using the GenUI Dart Workspace, you can simply run `melos run build_runner` from the root of the repository)*

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.