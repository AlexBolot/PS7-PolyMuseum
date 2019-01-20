import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

main(){
  testWidgets('Column Empty', (WidgetTester tester) async {
    var data = {
      'name': 'Column',
      'params': {},
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets('Column 1 Card', (WidgetTester tester) async {
    var data = {
      'name': 'Column',
      'params': {
        'children': [
          {'name': 'Card', 'params': {}}
        ]
      },
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('Column 1 Card', (WidgetTester tester) async {
    var data = {
      'name': 'Column',
      'params': {
        'children': [
          {'name': 'Card', 'params': {}},
          {'name': 'Card', 'params': {}},
        ]
      },
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));
  });
}