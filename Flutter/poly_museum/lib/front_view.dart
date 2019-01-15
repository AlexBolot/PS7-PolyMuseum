import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/ColorChanger.dart';

class FrontView extends StatefulWidget {
  final String title;

  FrontView({Key key, this.title}) : super(key: key);

  @override
  _FrontViewState createState() => _FrontViewState();
}

class _FrontViewState extends State<FrontView> {
  @override
  void initState() {
    super.initState();

    ColorUtils.changeColorsOf(context);
  }

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
              onPressed: () => moveTo('/MyHomePage'),
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

class ColorUtils extends _FrontViewState {
  static void changeColorsOf(context) {
    Firestore.instance.collection('Musées/NiceSport/plugins/ChangerCouleurs/config').document('current').get().then((appearance) {
        ColorChanger.of(context)?.color = Color.fromARGB(0xFF, appearance['color_red'], appearance['color_green'], appearance['color_blue']);
    });
  }
}

