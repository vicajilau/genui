# genui_builder

The code generation compiler for the GenUI ecosystem.

This package is responsible for the compile-time introspection of your Flutter widgets. It uses a powerful **Two-Phase Compilation** approach via Dart's `build_runner`, `analyzer`, and `source_gen` to read the Abstract Syntax Tree (AST) of classes annotated with `@generativeUI` (from the `genui_annotations` package).

By extracting these schemas at compile time, `genui_builder` ensures type safety, eliminates manual schema management, generates zero-cost widget factories, and completely avoids the overhead of runtime reflection on mobile devices.

---

## 📦 Installation

Since this package is only needed during development to generate code, you must add it to your `dev_dependencies` in your `pubspec.yaml`, alongside `build_runner`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations: any # (Resolved via Dart Workspaces or pub.dev)
  genui: any # (Official Google package)
  json_schema_builder: any

dev_dependencies:
  build_runner: ^2.15.0
  genui_builder: any # (Resolved via Dart Workspaces or pub.dev)
```

---

## ⚙️ How it Works: The Two-Phase Builder

When you run the build process, `genui_builder` executes a highly optimized sequence to generate both local schemas and a global entry point catalog.

### Phase 1: Local Introspection & CatalogItem Generation (`.genui.g.dart`)

The builder scans your project for any widget annotated with `@generativeUI`.

1. **Constructor Analysis:** It inspects the unnamed constructor of the class (ignoring the `key` parameter).
2. **Schema Compilation:** It maps Dart primitive types (`String`, `int`, `double`, `bool`) to type-safe schema definitions from `package:json_schema_builder/json_schema_builder.dart` (`S.string()`, `S.integer()`, `S.number()`, `S.boolean()`).
3. **Event Callback Wiring:** It automatically detects function callbacks (like `VoidCallback`) and maps them to dispatch interactive A2UI events (`itemContext.dispatchEvent(UserActionEvent(...))`) containing the current properties map, creating an automated two-way interaction loop.
4. **Adapter Generation:** It compiles a concrete `CatalogItem` containing the schema and a `widgetBuilder` that performs type-safe casting from raw JSON values to instantiate the widget.

### Phase 2: The Global Catalog Index (`genui_registry.g.dart`)

Once local files are analyzed, a secondary global builder takes over.

1. **Source Scanning:** It scans your original `.dart` files to detect all GenUI component schemas.
2. **Centralized Indexing:** It compiles a single, root-level file (`lib/genui_registry.g.dart`) containing a list of all items and a global `Catalog` (`globalGenUICatalog`).
3. **Zero Configuration:** This compiles all generated catalog items and automatically combines them with Google's official basic layout elements (Row, Column, Text, etc.). You can instantly inject the unified `globalGenUICatalog` into a `SurfaceController` with a single catalog reference.
4. **Schema Map & Helper Generation:** It generates in-memory schema maps (`globalGenUISchemas`), JSON-encoded string definitions (`globalGenUISchemasJson`), and a pre-formatted Markdown list (`globalGenUISchemasPromptDescription`) inside `genui_registry.g.dart` to completely remove boilerplate when constructing LLM system instructions on the client.

---

## 🚀 Usage

You do not need to import this package directly into your Dart code. It runs automatically in the background when you trigger the build system.

Ensure your annotated widgets include the exact part directive:

```dart
part 'your_file_name.genui.g.dart';
```

To generate the code, run:

```bash
dart run build_runner build
```

*(If you are using the GenUI Dart Workspace, you can simply run `melos run build_runner` from the root of the repository).*

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.