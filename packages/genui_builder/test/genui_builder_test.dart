import 'package:genui_builder/genui_builder.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = GenerativeUiGenerator();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.toString(), contains('GenerativeUiGenerator'));
    });
  });
}
