import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'genui_registry.g.dart';
import 'widgets/user_card_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GenUI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const GenUIDemoScreen(),
    );
  }
}

class GenUIDemoScreen extends StatefulWidget {
  const GenUIDemoScreen({super.key});

  @override
  State<GenUIDemoScreen> createState() => _GenUIDemoScreenState();
}

class _GenUIDemoScreenState extends State<GenUIDemoScreen> {
  late final SurfaceController _controller;
  late final SurfaceContext _surfaceContext;
  bool _isRendered = false;

  @override
  void initState() {
    super.initState();
    // 1. Initialize SurfaceController with our auto-generated Catalog
    _controller = SurfaceController(catalogs: [globalGenUICatalog]);
    _surfaceContext = _controller.contextFor('demo_surface');
  }

  void _renderUI() {
    // 2. Send A2UI message to create the surface
    _controller.handleMessage(
      CreateSurface(
        surfaceId: 'demo_surface',
        catalogId: 'inline_catalog',
        sendDataModel: false,
      ),
    );

    // 3. Send A2UI message to update components inside the surface
    _controller.handleMessage(
      UpdateComponents(
        surfaceId: 'demo_surface',
        components: [
          const Component(
            id: 'root',
            type: $UserCardWidgetIdentifier,
            properties: {
              'name': 'Ada Lovelace',
              'role': 'Lead Architect',
              'isActive': true,
            },
          ),
        ],
      ),
    );

    setState(() {
      _isRendered = true;
    });
  }

  void _clearUI() {
    _controller.handleMessage(DeleteSurface(surfaceId: 'demo_surface'));
    setState(() {
      _isRendered = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GenUI Demo'),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRendered)
                const Text(
                  'Press "Render UI" to build the Widget from JSON properties',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              else
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rendered by official package:genui Surface Widget:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 4. Render the dynamic Surface widget using our auto-generated CatalogItem!
                        Surface(surfaceContext: _surfaceContext),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRendered ? null : _renderUI,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Render UI'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _isRendered ? _clearUI : null,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
