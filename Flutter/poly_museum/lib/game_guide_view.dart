import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/ColorChanger.dart';
import 'package:poly_museum/model/game.dart';
import 'package:poly_museum/services/group_service.dart';

class GameGuideView extends StatefulWidget {
  final String title;

  GameGuideView({Key key, this.title}) : super(key: key);

  @override
  _GameGuideViewState createState() => _GameGuideViewState();
}

class _GameGuideViewState extends State<GameGuideView> {
  GroupService groupService = GroupService();
  Game game;
  String code = '';

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('appearance')
        .document('current')
        .get()
        .then((appearance) {
      ColorChanger.of(context)?.color = Color.fromARGB(
          0xFF,
          appearance['color_red'],
          appearance['color_green'],
          appearance['color_blue']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[],
        ),
      ),
    );
  }

  List<Widget> createColumn() {
    List list = new List();
    list.add(Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        child: FlatButton(
          child: Text('Arrêter le jeu',
              style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
          onPressed: () async {
            displayMessage("Fin du jeu.");
          },
        ),
      ),
    ));
    return list;
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Retour'),
            )
          ],
        );
      },
    );
  }
}
