import 'package:flutter_test/flutter_test.dart';

class TestCase {
  String name;
  Future Function() setUp;
  Future Function() body;
  Future Function() after;

  TestCase({this.name = 'Unknown test', this.setUp, this.body, this.after}) {
    this.setUp ??= () {};
    this.body ??= () {};
    this.after ??= () {};
  }

  Future<String> start() async {
    String result = '';
    try {
      await setUp();
      await body();
      await after();
      result = '$name : SUCCESS';
    } catch (error) {
      result = '$name : FAILED : $error';
    }

    print(result);
    return result;
  }

  static void assertSame(dynamic a, dynamic b) {
    if (a != b) throw Exception('assertSame failed, values are $a and $b');
  }

  static void assertTrue(bool a) {
    if (!a) throw Exception('assertTrue failed, value is $a');
  }

  static void assertFalse(bool a) {
    if (a) throw Exception('assertFalse failed, value is $a');
  }
}
