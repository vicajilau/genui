import 'package:genui_annotations/genui_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = GenerativeUI();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.name, equals('GenerativeUI'));
    });
  });
}
