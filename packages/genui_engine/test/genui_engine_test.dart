import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:genui_engine/genui_engine.dart';

void main() {
  group('GenUIEngine', () {
    late Map<
      String,
      ({
        dynamic Function(Map<String, dynamic>) fromJson,
        Map<String, dynamic> schema,
      })
    >
    registry;
    late GenUIEngine engine;

    setUp(() {
      registry = {
        'TextWidget': (
          fromJson: (props) => Text(props['text'] as String),
          schema: {'type': 'TextWidget'},
        ),
        'ContainerWidget': (
          fromJson: (props) => Container(
            color: props['color'] != null ? Color(props['color'] as int) : null,
            child: props['child'] != null
                ? Text(props['child'] as String)
                : null,
          ),
          schema: {'type': 'ContainerWidget'},
        ),
        'ThrowingWidget': (
          fromJson: (props) => throw Exception('Intentional factory error'),
          schema: {'type': 'ThrowingWidget'},
        ),
      };
      engine = GenUIEngine(registry: registry);
    });

    group('parse()', () {
      testWidgets('successfully parses a known widget with a flat structure', (
        WidgetTester tester,
      ) async {
        final widget = engine.parse({
          'type': 'TextWidget',
          'text': 'Hello GenUI',
        });

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('Hello GenUI'), findsOneWidget);
      });

      testWidgets(
        'successfully parses a known widget with a nested properties structure',
        (WidgetTester tester) async {
          final widget = engine.parse({
            'type': 'TextWidget',
            'properties': {'text': 'Nested Hello'},
          });

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.byType(Text), findsOneWidget);
          expect(find.text('Nested Hello'), findsOneWidget);
        },
      );

      testWidgets('returns a fallback error widget when "type" is missing', (
        WidgetTester tester,
      ) async {
        final widget = engine.parse({
          'properties': {'text': 'Missing type'},
        });

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(
          find.textContaining('Missing "type" or "component" key'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      });

      testWidgets(
        'returns a fallback error widget when component is not registered',
        (WidgetTester tester) async {
          final widget = engine.parse({
            'type': 'UnknownWidget',
            'text': 'Should fail',
          });

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

          expect(
            find.textContaining('Component "UnknownWidget" is not registered'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        },
      );

      testWidgets(
        'returns a fallback error widget when factory throws an exception',
        (WidgetTester tester) async {
          final widget = engine.parse({'type': 'ThrowingWidget'});

          await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

          expect(
            find.textContaining('Intentional factory error'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        },
      );
    });

    group('parseList()', () {
      testWidgets('successfully parses a list of valid JSON maps', (
        WidgetTester tester,
      ) async {
        final widgets = engine.parseList([
          {'type': 'TextWidget', 'text': 'Item 1'},
          {
            'type': 'TextWidget',
            'properties': {'text': 'Item 2'},
          },
        ]);

        expect(widgets.length, 2);

        await tester.pumpWidget(MaterialApp(home: Column(children: widgets)));

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('returns fallback error widgets for non-map items', (
        WidgetTester tester,
      ) async {
        final widgets = engine.parseList([
          {'type': 'TextWidget', 'text': 'Valid Item'},
          'This is just a string, not a map',
        ]);

        expect(widgets.length, 2);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Column(children: widgets)),
          ),
        );

        expect(find.text('Valid Item'), findsOneWidget);
        expect(
          find.textContaining('Expected a JSON object but got String'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      });
    });
  });
}
