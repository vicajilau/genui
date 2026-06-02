# genui_builder

The code generation engine for the GenUI ecosystem.

This package is responsible for the compile-time introspection of your Flutter widgets. It uses a powerful **Two-Phase Compilation** approach via Dart's `build_runner`, `analyzer`, and `source_gen` to read the Abstract Syntax Tree (AST) of classes annotated with `@generativeUI` (from the `genui_annotations` package).

By extracting these schemas at compile time, `genui_builder` ensures type safety, eliminates manual prompt synchronization, generates zero-cost instantiator functions, and completely avoids the overhead of runtime reflection on mobile devices.

## 📦 Installation

Since this package is only needed during development to generate code, you must add it to your `dev_dependencies` in your `pubspec.yaml`, alongside `build_runner`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations: any # (Resolved via Dart Workspaces or pub.dev)

dev_dependencies:
  build_runner: ^2.4.0
  genui_builder: any # (Resolved via Dart Workspaces or pub.dev)

```

## ⚙️ How it Works: The Two-Phase Builder

When you run the build process, `genui_builder` executes a highly optimized sequence to generate both local schemas and a global entry point.

### Phase 1: Local Introspection (`.genui.g.dart`)

The builder scans your project for any widget annotated with `@generativeUI`.

1. **AST Parsing:** It inspects the class fields (ignoring private and static properties).
2. **Schema Generation:** It maps Dart types to a flat JSON-compatible schema (`$ClassNameSchema`).
3. **Factory Generation:** It automatically writes a type-safe `fromJson` factory (`$ClassNameFromJson`) to instantiate the widget from the LLM's response.

### Phase 2: The Global Registry (`genui_registry.g.dart`)

Once the local files are analyzed, a secondary global builder takes over.

1. **Source Scanning:** It scans your original `.dart` files to detect all GenUI components.
2. **Centralized Indexing:** It assembles a single, root-level file (`lib/genui_registry.g.dart`) containing a `globalGenUIRegistry` map.
3. **Zero Configuration:** This allows the GenUI Engine to instantly know every available component in your app with a single import, avoiding manual wiring.

## 🚀 Usage

You do not need to import this package directly into your Dart code. It runs automatically in the background when you trigger the build system.

Ensure your annotated widgets include the exact part directive:

```dart
part 'your_file_name.genui.g.dart';

```

To generate the code, run:

```bash
dart run build_runner build --delete-conflicting-outputs

```

*(If you are using the GenUI Dart Workspace, you can simply run `melos run build_runner` from the root of the repository).*

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.