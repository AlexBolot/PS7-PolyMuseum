import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/test_class.dart';

void main() {
  // -------------- TestCase building -------------- //

  test('Empty TestCase', () async {
    var res = await TestCase().start();
    expect(res, equals('Unknown test : SUCESS'));
  });

  test('Named TestCase', () async {
    var res = await TestCase(name: 'Named Test').start();
    expect(res, equals('Named Test : SUCESS'));
  });

  test('Test with Setup', () async {
    var res = await TestCase(
      name: 'Setup Test',
      setUp: () {
        // This is an empty setUp
      },
    ).start();

    expect(res, equals('Setup Test : SUCESS'));
  });

  test('Test with Body', () async {
    var res = await TestCase(
      name: 'Body Test',
      body: () {
        // This is an empty body
      },
    ).start();

    expect(res, equals('Body Test : SUCESS'));
  });

  test('Test with After', () async {
    var res = await TestCase(
      name: 'After Test',
      after: () {
        // This is an empty body
      },
    ).start();

    expect(res, equals('After Test : SUCESS'));
  });

  test('Testing order of execution', () async {
    int i = 0;

    TestCase(
      name: 'Order of Execution',
      setUp: () {
        TestCase.assertSame(i, 0);
        i++;
      },
      body: () {
        TestCase.assertSame(i, 1);
        i++;
      },
      after: () {
        TestCase.assertSame(i, 2);
        i++;
      },
    ).start();
  });

  // -------------- Assert True -------------- //

  group('Testing "AssertTrue" method', () {
    test('assertTrue of true', () => TestCase.assertTrue(true));

    test('assertTrue of false', () {
      try {
        TestCase.assertTrue(false);

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertTrue did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });

    test('assertTrue of null', () {
      try {
        TestCase.assertTrue(null);

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertTrue did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });
  });

  // -------------- Assert True -------------- //

  group('Testing "AssertFalse" method', () {
    test('assertFalse of false', () => TestCase.assertFalse(false));

    test('assertFalse of true', () {
      try {
        TestCase.assertFalse(true);

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertFalse did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });

    test('assertFalse of null', () {
      try {
        TestCase.assertFalse(null);

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertFalse did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });
  });

  // -------------- Assert Same -------------- //

  group('Testing "AssertSame" method', () {
    test('assertSame true on Strings', () => TestCase.assertSame('aaa', 'aaa'));

    test('assertSame true on int', () => TestCase.assertSame(2, 2));

    test('assertSame false on Strings', () {
      try {
        TestCase.assertSame('aaa', 'bbb');

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertFalse did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });

    test('assertSame false on integer', () {
      try {
        TestCase.assertSame(2, 3);

        //If we didn't catch an error, it's a fail :/
        fail('TestCase.assertFalse did not trigger Exception');
      } catch (error) {
        //If we catch an error, it's a success :)
      }
    });
  });
}
