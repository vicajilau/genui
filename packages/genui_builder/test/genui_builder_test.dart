import 'package:genui_builder/genui_builder.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = GenerativeUIGenerator();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.toString(), contains('GenerativeUIGenerator'));
    });
  });
}
