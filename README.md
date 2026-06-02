# GenUI: On-Device Generative UI for Flutter

The on-device Generative UI ecosystem for Flutter. GenUI combines local LLM inference with declarative widget introspection to render dynamic, privacy-first interfaces without cloud dependencies.

Unlike traditional Server-Driven UI (SDUI), GenUI empowers offline-first applications by generating and rendering user interfaces strictly on-device using Small Language Models (SLMs) and GGUF files.

## 🚀 Key Features

* **100% Local & Privacy-First:** No cloud accounts, no API keys, and no network latency. Everything runs on the user's device.
* **Compile-Time Introspection:** Uses Dart's AST (Abstract Syntax Tree) and `build_runner` to automatically extract widget schemas.
* **Two-Phase Code Generation:** Generates highly optimized local component schemas AND automatically assembles a central `genui_registry.g.dart` index. No manual wiring required.
* **Native Dart Workspaces:** Built on top of Dart 3.5+ Pub Workspaces for blazing-fast, conflict-free monorepo management.
* **Developer Experience (DX):** Just add `@generativeUI`. The build system handles schema mapping, global component registration, and even generates the LLM prompt for you.

## ✨ The "Magic" Developer Experience (DX)

GenUI is designed to get out of your way. We hated manually wiring up components and writing endless JSON schemas by hand, so we automated everything.

1. **Zero Boilerplate:** Decorate your Flutter widget with `@generativeUI(format: SchemaFormat.a2ui)`. That's it.
2. **Global Auto-Discovery:** You don't need to manually register your widgets into a massive list. The `genui_builder` crawls your entire project and creates a single `globalGenUIRegistry` containing everything.
3. **Automatic LLM Prompts:** The `GenUIEngine` knows exactly what widgets exist and what properties they accept. Call `engine.buildSystemPrompt()` to instantly get a perfectly structured text prompt containing the JSON schemas of your entire app. Just send this directly to your LLM!
4. **Resilient Parsing:** If the LLM hallucinates a non-existent widget or forgets a required property, the engine will gracefully render a fallback error widget instead of crashing your app.

## 📁 Workspace Structure

This monorepo utilizes Dart Pub Workspaces and Melos (for script execution) to ensure clean dependency graphs and maximum reusability.

| Package | Description |
| --- | --- |
| [`genui_annotations`](./packages/genui_annotations) | Lightweight contract package containing the `@generativeUI` annotation. Safe to include in production code with zero dependencies. |
| [`genui_builder`](./packages/genui_builder) | The AST code generator utilizing `build_runner` and `analyzer` to extract component schemas and build the global registry at compile time. |
| [`genui_engine`](./packages/genui_engine) | The core runtime engine that safely maps JSON payloads to native Flutter widgets using the pre-compiled registry, without runtime reflection. |
| [`example`](./example) | The playground Flutter app demonstrating the generation and registry integration. |

*(Note: The local LLM execution environment will be added as an independent package in future iterations).*

## 🛠️ Getting Started

### Prerequisites

Ensure you have **Dart SDK ^3.6.0** (or the equivalent Flutter SDK) installed to support modern Pub Workspaces. You also need Melos activated globally for script management.

```bash
# Activate Melos globally
dart pub global activate melos

```

### Setup the Workspace

Clone the repository and resolve dependencies. Thanks to Dart Workspaces, `pub get` automatically links the local packages. **Do not use `melos bootstrap`.**

```bash
git clone https://github.com/vicajilau/genui.git
cd genui

# Link dependencies natively across the workspace
dart pub get

```

### Code Generation

This project uses a highly optimized 2-phase builder. To generate your UI schemas and the global registry, run:

```bash
# Triggers code generation across all workspace packages
melos run build_runner

```

## 📖 Usage Example

### 1. Annotate your Widgets

Import the annotations package in your Flutter app, decorate your widgets, and include the `.genui.g.dart` part directive.

```dart
import 'package:flutter/material.dart';
import 'package:genui_annotations/genui_annotations.dart';

// Must match the file name exactly
part 'user_card.genui.g.dart';

@generativeUI
class UserCard extends StatelessWidget {
  final String username;
  final String role;

  const UserCard({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(username),
        subtitle: Text(role),
      ),
    );
  }
}

```

### 2. Consume the Global Registry

Run the build command. GenUI will automatically generate the schema and export it to a global registry at the root of your `lib/` folder, ready to be injected into the Engine.

```dart
import 'package:flutter/material.dart';

// Auto-generated by Phase 2 of GenUI Builder
import 'genui_registry.g.dart'; 

void main() {
  // Inject the global registry into the engine. Zero manual configuration!
  // final engine = GenUIEngine(registry: globalGenUIRegistry);
  
  runApp(const MainApp());
}

```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.