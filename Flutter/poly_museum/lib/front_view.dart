import 'package:flutter/material.dart';

class FrontView extends StatefulWidget {
  final String title;

  FrontView({Key key, this.title}) : super(key: key);

  @override
  _FrontViewState createState() => _FrontViewState();
}

class _FrontViewState extends State<FrontView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Bienvenue dans le Musée du Sport de Nice',
                style: TextStyle(fontSize: 26.0),
              ),
            ),
            RaisedButton(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Text(
                  'Entrer dans le musée',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.grey[300],
              onPressed: () => moveTo('/VisitorHomePage'),
            ),
            RaisedButton(
              elevation: 4.0,
              child: Text('Accès réservé Guide'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.grey[300],
              onPressed: () => moveTo('/GuideView'),
            )
          ],
        ),
      ),
    );
  }

  moveTo(String pageName) => Navigator.of(context).pushNamed(pageName);
}
