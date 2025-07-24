import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tabx/flutter_tabx.dart';

void main() {
  group('TabXController', () {
    test('initial index and length are correct', () {
      final controller = TabXController(length: 5, initialIndex: 2);
      expect(controller.length, 5);
      expect(controller.index, 2);
    });

    test('setting index updates correctly and notifies listeners', () {
      final controller = TabXController(length: 3);
      var listenerCalled = false;
      controller.addListener(() {
        listenerCalled = true;
      });

      controller.index = 1;
      expect(controller.index, 1);
      expect(listenerCalled, isTrue);

      listenerCalled = false;
      controller.index = 1; // Setting to same index should not notify
      expect(listenerCalled, isFalse);
    });

    test('updateLength changes length and adjusts index if out of bounds', () {
      final controller = TabXController(length: 5, initialIndex: 4);
      var listenerCalled = false;
      controller.addListener(() {
        listenerCalled = true;
      });

      controller.updateLength(3);
      expect(controller.length, 3);
      expect(controller.index, 2); // Index adjusted from 4 to 2
      expect(listenerCalled, isTrue);

      listenerCalled = false;
      controller.updateLength(3); // Setting to same length should not notify
      expect(listenerCalled, isFalse);

      controller.updateLength(5);
      expect(controller.length, 5);
      expect(controller.index, 2); // Index remains 2
      expect(listenerCalled, isTrue);
    });

    test('jumpTo updates index and notifies listeners', () {
      final controller = TabXController(length: 3);
      var listenerCalled = false;
      controller.addListener(() {
        listenerCalled = true;
      });

      controller.jumpTo(2);
      expect(controller.index, 2);
      expect(listenerCalled, isTrue);
    });

    test('next loops correctly', () {
      final controller = TabXController(length: 3, initialIndex: 0);
      controller.next();
      expect(controller.index, 1);
      controller.next();
      expect(controller.index, 2);
      controller.next();
      expect(controller.index, 0); // Loops back
    });

    test('previous loops correctly', () {
      final controller = TabXController(length: 3, initialIndex: 0);
      controller.previous();
      expect(controller.index, 2); // Loops back
      controller.previous();
      expect(controller.index, 1);
      controller.previous();
      expect(controller.index, 0);
    });

    test('asserts for invalid initial index or length', () {
      expect(() => TabXController(length: 0), throwsA(isA<AssertionError>()));
      expect(() => TabXController(length: 3, initialIndex: -1),
          throwsA(isA<AssertionError>()));
      expect(() => TabXController(length: 3, initialIndex: 3),
          throwsA(isA<AssertionError>()));
    });
  });
}
