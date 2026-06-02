# genui_annotations

The core annotations package for the GenUI ecosystem.

This lightweight package provides the `@generativeUI` annotation, which is used to mark Flutter widgets for compile-time introspection. By keeping annotations separate from the builder logic, this package ensures your production code remains clean and free of heavy code-generation dependencies like `analyzer` or `build_runner`.

## 📦 Installation

Add `genui_annotations` to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations: any # (Resolved via Dart Workspaces or pub.dev)

```

*Note: You will also need to add `genui_builder` and `build_runner` to your `dev_dependencies` to actually generate the code.*

## 🚀 Usage

Simply import the package and apply the `@generativeUI` annotation to any Flutter widget you want the local LLM to be able to render. You can change the generated JSON schema format using the `format` parameter.

```dart
import 'package:flutter/material.dart';
import 'package:genui_annotations/genui_annotations.dart';

// The part directive must match the file name exactly with the .genui.g.dart extension
part 'my_button.genui.g.dart';

// You can use the default @generativeUI, or customize the format:
// @GenerativeUI(format: SchemaFormat.a2ui)
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
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Colors.grey,
      ),
      child: Text(label),
    );
  }
}
```

### 🛠️ Supported Schema Formats

When applying the annotation, you can specify the format of the generated JSON schema. The format you choose changes the structure of the JSON payload you expect the LLM to return.

From a **Developer Experience (DX)** perspective, choosing the right format ensures your Flutter renderer maps smoothly to the capabilities of the LLM you are using.

#### 1. `SchemaFormat.flat` (Default)
Generates a schema based on a standard `type` and `properties` structure.

```json
{
  "type": "MyButton",
  "properties": {
    "label": "String",
    "isPrimary": "bool"
  }
}
```

**Why use it (DX Perspective):** 
This is the simplest and most intuitive format. It consumes fewer tokens and is easily understood by generic, non-specialized LLMs (like standard Gemini, GPT-4, or Claude). Use this if you are prototyping, writing your own system prompts, or using a model that isn't fine-tuned for a specific UI schema.

#### 2. `SchemaFormat.a2ui`
Generates a schema aligned with Google's **Agent to UI (A2UI)** specification, wrapping fields inside a `props` object and defining the type as `component`.

```json
{
  "component": "MyButton",
  "props": {
    "label": "String",
    "isPrimary": "bool"
  }
}
```
**Why use it (DX Perspective):** 
A2UI is a standardized UI contract. If your LLM is already fine-tuned to emit the A2UI format, or if you are working in a larger ecosystem that shares Server-Driven UI definitions across Android, iOS, and Web, this format ensures strict compliance. It saves you from having to write custom parsers to translate generic JSON into your enterprise schema.

Once your widgets are annotated, run the build command from the root of your project or workspace to generate the static JSON schemas, the instantiator functions, and the global registry:

```bash
dart run build_runner build --delete-conflicting-outputs

```

*(If you are using the GenUI Dart Workspace, you can simply run `melos run build_runner`)*

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.