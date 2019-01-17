import 'package:flutter_test/flutter_test.dart';

class TestCase {
  Future Function() setUp;
  Future Function() body;
  Future Function() after;

  TestCase({this.setUp, this.body, this.after});

  void start() async {
    if (setUp != null) {
      await setUp();
    }

    await body();

    if (after != null) {
      await after();
    }
  }

  static void assertSame(dynamic a, dynamic b) {
    if (a != b) throw 'assertSame failed, values are $a and $b';
  }

  static void assertTrue(bool a) {
    if (!a) throw 'assertTrue failed, value is $a';
  }

  static void assertFalse(bool a) {
    if (a) throw 'assertFalse failed, value is $a';
  }
}
