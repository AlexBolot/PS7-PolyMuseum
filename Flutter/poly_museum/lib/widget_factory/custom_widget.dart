import 'package:flutter/material.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

class CustomWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  CustomWidget(this.data);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  List<Map<String, dynamic>> views = [];
  int index = 0;

  @override
  void initState() {
    super.initState();

    views.add({});
    views.add({
      'viewName': 'This is a build view',
      'buttons': ['previous'],
      'body': {
        'name': 'Column',
        'params': {
          'mainAxisAlignment': 'spaceEvenly',
          'crossAxisAlignment': 'center',
          'children': [
            {
              'name': 'Card',
              'params': {
                'topMargin': 1.0,
                'rightMargin': 1.0,
                'bottomMargin': 1.0,
                'leftMargin': 1.0,
                'elevation': 8.0,
                'child': {
                  'name': 'Padding',
                  'params': {
                    'topPadding': 32.0,
                    'rightPadding': 32.0,
                    'bottomPadding': 32.0,
                    'leftPadding': 32.0,
                    'child': {
                      'name': 'Text',
                      'params': {'value': 'Hello there 2'}
                    }
                  }
                }
              }
            },
            {
              'name': 'Card',
              'params': {
                'colorValue': 13137970,
                'topMargin': 1.0,
                'rightMargin': 1.0,
                'bottomMargin': 1.0,
                'leftMargin': 1.0,
                'elevation': 8.0,
                'child': {
                  'name': 'Padding',
                  'params': {
                    'topPadding': 32.0,
                    'rightPadding': 32.0,
                    'bottomPadding': 32.0,
                    'leftPadding': 32.0,
                    'child': {
                      'name': 'Text',
                      'params': {'value': 'General Kenobi 2'}
                    }
                  }
                }
              }
            },
            {
              'name': 'Container',
              'params': {
                'width': 250.0,
                'height': 250.0,
                'child': {
                  'name': 'Image',
                  'params': {
                    'source': 'https://bit.ly/2Dmukje',
                  }
                }
              }
            }
          ]
        },
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data['viewName'])),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional(0.0, 1.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: WidgetFactory(widget.data['body']).build(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _bottomButtons(widget.data['buttons']),
            ),
          ],
        ),
      ),
    );
  }

  _bottomButtons(List buttons) {
    if (buttons.isEmpty) return Container();

    Widget previous = FloatingActionButton(
      heroTag: null,
      child: Icon(Icons.arrow_back),
      onPressed: () {
        setState(() {
          //if (index > 0) index--;
        });
      },
    );

    Widget next = FloatingActionButton(
      heroTag: null,
      child: Icon(Icons.arrow_forward),
      onPressed: () {
        setState(() {
          //if (index < views.length - 1) index++;
        });
      },
    );

    if (buttons.contains('next') && buttons.contains('previous')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[previous, next],
      );
    }

    if (buttons.contains('previous')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[previous],
      );
    }

    if (buttons.contains('next')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[next],
      );
    }
  }
}
