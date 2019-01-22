import 'package:flutter/material.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/services/group_service.dart';
import 'package:poly_museum/services/object_research_game_service.dart';
import 'package:poly_museum/services/service_provider.dart';
import 'package:uuid/uuid.dart';

class GuideView extends StatefulWidget {
  final String title;

  GuideView({Key key, this.title}) : super(key: key);

  @override
  _GuideViewState createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  GroupService groupService = ServiceProvider.groupService;
  ObjectResearchGameService gameService = ServiceProvider.gameService;
  String code = '';

  _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(16.0),
              elevation: 8.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                child: FlatButton(
                  child: Text('Créer groupe',
                      style:
                          TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
                  onPressed: () async {
                    groupService.streamGroups();

                    List<int> list = groupService.groupIDs..sort();
                    code = _randomCode();

                    groupService.createGroup(list[list.length - 1] + 1, code);
                    groupService.dispose();

                    displayCode(code);
                  },
                ),
              ),
            ),
            displayLaunchGame(),
          ],
        ),
      ),
    );
  }

  ///Generate a randomCode
  String _randomCode() {
    return Uuid().v1().toString().substring(0, 5).toUpperCase();
  }

  Widget displayLaunchGame() {
    if (code.isEmpty) {
      return Container();
    }
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        child: FlatButton(
          child: Text('Lancer un jeu avec le dernier groupe crée',
              style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
          onPressed: () async {
            gameService.startGame(_refresh, currentGroupID);
            moveTo('/GameGuideView');
          },
        ),
      ),
    );
  }

  ///Method to move to another view of the app
  moveTo(String pageName) => Navigator.of(context).pushNamed(pageName);

  void displayCode(String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Code du groupe : $code'),
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
