import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:example/main.dart';
import 'package:example/genui_registry.g.dart';
import 'package:example/presentation/widgets/catalog/user_card_widget.dart';
import 'package:example/presentation/widgets/catalog/metric_chart_widget.dart';
import 'package:example/presentation/widgets/catalog/priority_pill_widget.dart';
import 'package:example/presentation/widgets/catalog/attachment_list_widget.dart';
import 'package:example/presentation/widgets/catalog/timeline_widget.dart';

void main() {
  testWidgets('App renders UserCardWidget from JSON', (
    WidgetTester tester,
  ) async {
    // Set desktop window size to ensure the catalog panel is fully visible in wide layout
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that we are on the Component Catalog tab showing CustomButton preview initially
    expect(find.text('CustomButton'), findsOneWidget);

    // Tap 'User Card' sidebar item to switch to it
    await tester.tap(find.text('User Card'));
    await tester.pumpAndSettle();

    // Verify that the UserCardWidget is rendered with the mocked JSON data.
    expect(find.byType(UserCardWidget), findsOneWidget);

    // Verify the details specifically within the UserCardWidget to avoid matching input fields in the editor panel
    expect(
      find.descendant(
        of: find.byType(UserCardWidget),
        matching: find.text('Ada Lovelace'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(UserCardWidget),
        matching: find.text('Lead Architect'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(UserCardWidget),
        matching: find.text('ACTIVE'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Catalog builds UserCardWidget from CatalogItemContext', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node',
                type: $UserCardWidgetIdentifier,
                data: const {
                  'name': 'Alan Turing',
                  'role': 'Computer Scientist',
                  'isActive': false,
                },
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(UserCardWidget), findsOneWidget);
    expect(find.text('Alan Turing'), findsOneWidget);
    expect(find.text('Computer Scientist'), findsOneWidget);
    expect(find.text('OFFLINE'), findsOneWidget);
  });

  testWidgets('Catalog builds UserCardWidget with avatarUrl', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node_avatar',
                type: $UserCardWidgetIdentifier,
                data: const {
                  'name': 'Grace Hopper',
                  'role': 'Computer Scientist',
                  'isActive': true,
                  'avatarUrl': 'https://example.com/avatar.jpg',
                },
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(UserCardWidget), findsOneWidget);
    expect(find.byType(ClipOval), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Catalog builds MetricChartWidget from CatalogItemContext', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node_chart',
                type: $MetricChartWidgetIdentifier,
                data: const {
                  'title': 'Project Completion',
                  'value': 0.85,
                  'legendLabel': 'Done',
                  'colorHex': '#6366F1',
                },
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(MetricChartWidget), findsOneWidget);
    expect(find.text('Project Completion'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets(
    'Catalog builds MetricChartWidget from CatalogItemContext when value is double/int (safe parsing)',
    (WidgetTester tester) async {
      final catalog = globalGenUICatalog;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                final catalogContext = CatalogItemContext(
                  id: 'test_node_chart_int',
                  type: $MetricChartWidgetIdentifier,
                  data: const {
                    'title': 'Completion Int',
                    'value': 1,
                    'legendLabel': 'Finished',
                    'colorHex': '#6366F1',
                  },
                  dispatchEvent: (_) {},
                  buildChild: (_, [_]) => const SizedBox.shrink(),
                  buildContext: context,
                  dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                  getComponent: (_) => null,
                  getCatalogItem: (_) => null,
                  surfaceId: 'test_surface',
                  reportError: (_, [_]) {},
                );

                return catalog.buildWidget(catalogContext);
              },
            ),
          ),
        ),
      );

      expect(find.byType(MetricChartWidget), findsOneWidget);
      expect(find.text('Completion Int'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Finished'), findsOneWidget);
    },
  );

  testWidgets(
    'Catalog builds MetricChartWidget from CatalogItemContext when value is > 1.0 (e.g. 88)',
    (WidgetTester tester) async {
      final catalog = globalGenUICatalog;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                final catalogContext = CatalogItemContext(
                  id: 'test_node_chart_large',
                  type: $MetricChartWidgetIdentifier,
                  data: const {
                    'title': 'Storage Use',
                    'value': 88,
                    'legendLabel': 'Lleno',
                    'colorHex': '#EF4444',
                  },
                  dispatchEvent: (_) {},
                  buildChild: (_, [_]) => const SizedBox.shrink(),
                  buildContext: context,
                  dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                  getComponent: (_) => null,
                  getCatalogItem: (_) => null,
                  surfaceId: 'test_surface',
                  reportError: (_, [_]) {},
                );

                return catalog.buildWidget(catalogContext);
              },
            ),
          ),
        ),
      );

      expect(find.byType(MetricChartWidget), findsOneWidget);
      expect(find.text('Storage Use'), findsOneWidget);
      expect(find.text('88%'), findsOneWidget);
      expect(find.text('Lleno'), findsOneWidget);
    },
  );

  testWidgets('Catalog builds PriorityPillWidget from CatalogItemContext', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node_pill',
                type: $PriorityPillWidgetIdentifier,
                data: const {'priority': 'high', 'label': 'CRITICAL'},
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(PriorityPillWidget), findsOneWidget);
    expect(find.text('CRITICAL'), findsOneWidget);
  });

  testWidgets('Catalog builds AttachmentListWidget from CatalogItemContext', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node_attachments',
                type: $AttachmentListWidgetIdentifier,
                data: const {
                  'title': 'Project Files',
                  'items': [
                    {'name': 'document.pdf', 'type': 'pdf', 'size': '1.5 MB'},
                  ],
                },
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(AttachmentListWidget), findsOneWidget);
    expect(find.text('Project Files'), findsOneWidget);
    expect(find.text('document.pdf'), findsOneWidget);
    expect(find.text('1.5 MB'), findsOneWidget);
  });

  testWidgets('Catalog builds TimelineWidget from CatalogItemContext', (
    WidgetTester tester,
  ) async {
    final catalog = globalGenUICatalog;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              final catalogContext = CatalogItemContext(
                id: 'test_node_timeline',
                type: $TimelineWidgetIdentifier,
                data: const {
                  'title': 'System Status Log',
                  'events': [
                    {
                      'title': 'Server Started',
                      'description': 'Main cluster operational.',
                      'timestamp': '10:00 AM',
                      'status': 'completed',
                    },
                    {
                      'title': 'Backup Database',
                      'description': 'Replicating storage.',
                      'timestamp': '10:15 AM',
                      'status': 'active',
                    },
                    {
                      'title': 'Health Check',
                      'description': 'Verify nodes.',
                      'timestamp': '11:00 AM',
                      'status': 'pending',
                    },
                  ],
                },
                dispatchEvent: (_) {},
                buildChild: (_, [_]) => const SizedBox.shrink(),
                buildContext: context,
                dataContext: DataContext(InMemoryDataModel(), DataPath.root),
                getComponent: (_) => null,
                getCatalogItem: (_) => null,
                surfaceId: 'test_surface',
                reportError: (_, [_]) {},
              );

              return catalog.buildWidget(catalogContext);
            },
          ),
        ),
      ),
    );

    expect(find.byType(TimelineWidget), findsOneWidget);
    expect(find.text('System Status Log'), findsOneWidget);
    expect(find.text('Server Started'), findsOneWidget);
    expect(find.text('Main cluster operational.'), findsOneWidget);
    expect(find.text('Backup Database'), findsOneWidget);
    expect(find.text('Health Check'), findsOneWidget);
  });
}
