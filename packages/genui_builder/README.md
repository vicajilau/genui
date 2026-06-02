# genui_builder

The code generation engine for the GenUI ecosystem. 

This package is responsible for the compile-time introspection of your Flutter widgets. It uses Dart's `analyzer` and `source_gen` to read the Abstract Syntax Tree (AST) of classes annotated with `@GenerativeUI` (from the `genui_annotations` package) and automatically generates the static JSON schemas required to feed local LLMs.

By extracting these schemas at compile time, `genui_builder` ensures type safety, eliminates manual prompt synchronization, and completely avoids the overhead of runtime reflection on mobile devices.

## 📦 Installation

Since this package is only needed during development to generate code, you must add it to your `dev_dependencies` in your `pubspec.yaml`, alongside `build_runner`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui_annotations:
    path: ../genui_annotations # (Update this with the pub.dev version once published)

dev_dependencies:
  build_runner: ^2.4.0
  genui_builder:
    path: ../genui_builder # (Update this with the pub.dev version once published)
```

## ⚙️ How it Works

When you run the build process, `genui_builder` scans your project for any widget annotated with `@GenerativeUI`. 

1. **AST Parsing:** It inspects the class fields (ignoring private and static properties).
2. **Schema Generation:** It maps Dart types to a flat JSON-compatible schema.
3. **Output:** It generates a `.genui.g.dart` file containing a static `Map<String, dynamic>` that represents the component's structure.

This generated map can then be safely injected into the system prompt of your local on-device model (e.g., via `llama.cpp` bindings), telling the model exactly what "building blocks" it has available to construct the UI.

## 🚀 Usage

You do not need to import this package directly into your Dart code. It runs automatically in the background when you trigger the build system.

To generate the code, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

*(If you are using the GenUI Melos workspace, you can simply run `melos run build_runner` from the root of the repository).*

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.