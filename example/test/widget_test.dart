import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_engine/genui_engine.dart';
import 'package:example/main.dart';
import 'package:example/genui_registry.g.dart';
import 'package:example/widgets/user_card_widget.dart';

void main() {
  testWidgets('App renders UserCardWidget from JSON', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    final engine = GenUIEngine(registry: globalGenUIRegistry);
    await tester.pumpWidget(MainApp(engine: engine, simulateLlmStream: false));

    // Tap 'Start' button to begin rendering
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the title text is rendered.
    expect(find.text('GenUI Demo'), findsOneWidget);
    expect(find.text('Rendered purely from JSON:'), findsOneWidget);

    // Verify that the UserCardWidget is rendered with the mocked JSON data.
    expect(find.byType(UserCardWidget), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Lead Architect'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('Engine successfully parses arbitrary JSON to UserCardWidget', (
    WidgetTester tester,
  ) async {
    final engine = GenUIEngine(registry: globalGenUIRegistry);

    final jsonPayload = {
      "type": "UserCardWidget",
      "properties": {
        "name": "Alan Turing",
        "role": "Computer Scientist",
        "isActive": false,
      },
    };

    final widget = engine.parse(jsonPayload);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    expect(find.byType(UserCardWidget), findsOneWidget);
    expect(find.text('Alan Turing'), findsOneWidget);
    expect(find.text('Computer Scientist'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
  });
}
