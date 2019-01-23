import 'package:flutter/material.dart';
import 'package:poly_museum/widget_factory/widget_factory.dart';

class CustomWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  CustomWidget(this.data);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);

    return Scaffold(
      appBar: AppBar(title: Text('Exposition Coupe du Monde')),//Text(widget.data['viewName'])),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional(0.0, 1.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: WidgetFactory(widget.data).build(),
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
    if (buttons == null || buttons.isEmpty) return Container();

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
