import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

import '../testing_utils.dart';

main(){
  testWidgets('Card Empty', (WidgetTester tester) async {
    var data = {
      'name': 'Card',
      'params': {},
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('Card with Text', (WidgetTester tester) async {
    var data = {
      'name': 'Card',
      'params': {
        'child': {
          'name': 'Text',
          'params': {'value': 'testText'}
        }
      },
    };

    await tester.pumpWidget(WidgetFactory(data).build());
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.widgetWithText(Card, 'testText'), findsOneWidget);

    Card card = tester.firstWidget(find.byType(Card));
    expectType<Text>(card.child);
  });
}