import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:example/main.dart';
import 'package:example/genui_registry.g.dart';
import 'package:example/presentation/widgets/catalog/user_card_widget.dart';

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
}
