import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

main(){
  testWidgets('Row Empty', (WidgetTester tester) async {
    var data = {
      'name': 'Row',
      'params': {},
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('Row 1 Card', (WidgetTester tester) async {
    var data = {
      'name': 'Row',
      'params': {
        'children': [
          {'name': 'Card', 'params': {}}
        ]
      },
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('Row 1 Card', (WidgetTester tester) async {
    var data = {
      'name': 'Row',
      'params': {
        'children': [
          {'name': 'Card', 'params': {}},
          {'name': 'Card', 'params': {}},
        ]
      },
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));
  });
}