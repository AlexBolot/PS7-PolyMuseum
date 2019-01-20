
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

expectType<T>(dynamic value) {
  expect(true, TypeMatcher<T>().check(value));
}
