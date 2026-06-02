# GenUI: On-Device Generative UI for Flutter

The on-device Generative UI ecosystem for Flutter. GenUI combines local LLM inference (llama.cpp via Dart FFI) with declarative widget introspection to render dynamic, privacy-first interfaces without cloud dependencies.

Unlike traditional Server-Driven UI (SDUI), GenUI empowers offline-first applications by generating and rendering user interfaces strictly on-device using Small Language Models (SLMs) and GGUF files.

## 🚀 Key Features

* **100% Local & Privacy-First:** No cloud accounts, no API keys, and no network latency. Everything runs on the user's device.
* **Compile-Time Introspection:** Uses Dart's AST (Abstract Syntax Tree) and code generation to automatically extract widget schemas.
* **Fault-Tolerant Streaming:** Designed to parse and render flat JSON arrays token-by-token, avoiding the crashes associated with deeply nested A2UI responses on small models.
* **Developer Experience (DX):** Simply annotate your Flutter widgets with `@GenerativeUi` and let the build system handle the complex prompt engineering.

## 📁 Workspace Structure

This project is a monorepo managed with [Melos](https://melos.invertase.dev/). It is divided into modular packages to ensure clean dependency graphs and maximum reusability.

| Package | Description |
|---|---|
| [`genui_annotations`](./packages/genui_annotations) | Lightweight contract package containing the `@GenerativeUi` annotation. Safe to include in production code without bloating the app. |
| [`genui_builder`](./packages/genui_builder) | The AST code generator utilizing `build_runner` and `analyzer` to extract component schemas at compile time. |

*(Note: The core rendering engine and GGUF execution environment will be added as independent packages in future iterations).*

## 🛠️ Getting Started

### Prerequisites

Ensure you have the Dart SDK installed. This workspace relies on `melos` to manage local dependencies and run scripts across packages.

```bash
# Activate Melos globally
dart pub global activate melos
```

### Bootstrap the Project

Clone the repository and bootstrap the workspace. This command will automatically link the local packages (e.g., linking `genui_annotations` into `genui_builder`).

```bash
git clone https://github.com/WidgetSuite/genui.git
cd genui

# Link dependencies and set up the workspace
melos bootstrap
```

### Useful Commands

This monorepo includes several custom Melos scripts for your convenience:

* `melos run build_runner`: Triggers code generation across all packages that require it.
* `melos run analyze`: Runs the Dart analyzer across the entire workspace to check for linting errors.

## 📖 Usage Example

Import the annotations package in your Flutter app and decorate the widgets you want the local LLM to be able to render.

```dart
import 'package:flutter/material.dart';
import 'package:genui_annotations/genui_annotations.dart';

part 'user_card.g.dart';

@GenerativeUi(name: 'UserProfileCard')
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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.