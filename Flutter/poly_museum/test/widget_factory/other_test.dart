import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

main(){
  testWidgets('Factory Empty', (WidgetTester tester) async {
    var data = {
      'name': '',
      'params': {},
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Text', (WidgetTester tester) async {
    var data = {
      'name': 'Text',
      'params': {'value': 'testText'},
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.text('testText'), findsOneWidget);
  });

}