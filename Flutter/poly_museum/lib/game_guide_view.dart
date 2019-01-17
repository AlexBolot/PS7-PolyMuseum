import 'package:flutter/material.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/ColorChanger.dart';
import 'package:poly_museum/services/group_service.dart';
import 'package:poly_museum/services/object_research_game_service.dart';
import 'package:poly_museum/services/service_provider.dart';

class GameGuideView extends StatefulWidget {
  final String title;

  GameGuideView({Key key, this.title}) : super(key: key);

  @override
  _GameGuideViewState createState() => _GameGuideViewState();
}

class _GameGuideViewState extends State<GameGuideView> {
  GroupService groupService = ServiceProvider.groupService;
  ObjectResearchGameService gameService = ServiceProvider.gameService;

  String code = currentGroupID;

  @override
  void initState() {
    super.initState();
    gameService.getTeams(_refresh, currentGroupID);
    gameService.updateResearchGameDescriptions(_refresh, globalUserGroup);
  }

  VoidCallback _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    gameService.disposeObjectsDiscoveredStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(mainAxisSize: MainAxisSize.max, children: createColumn()),
      ),
    );
  }

  List<Widget> createColumn() {
    List list = new List<Widget>();
    list.add(Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        child: FlatButton(
          child: Text('Arrêter le jeu', style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
          onPressed: () async {
            gameService.endGame(_refresh, currentGroupID);
            displayMessage("Fin du jeu.");
          },
        ),
      ),
    ));
    Map<int, String> map = new Map();
    for (String s in gameService.teamsGame) {
      List t = s.split(":");
      map.update(int.parse(t[0]), (String) => map[int.parse(t[0])] + ", " + t[1], ifAbsent: () => t[1]);
    }
    for (int i in map.keys) {
      list.add(Card(
        margin: EdgeInsets.all(16.0),
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: ListTile(
            title: Text('Equipe ' + i.toString(), style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
            subtitle: Text(map[i]),
          ),
        ),
      ));
    }
    list.add(displayEndGame());
    return list;
  }

  ///Widget that display the winning team
  Widget displayEndGame() {
    if (gameService.winningTeam != -1) {
      String winningTeam = gameService.winningTeam.toString();
      return Card(
        margin: EdgeInsets.all(16.0),
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: FlatButton(
            child: Text("L'équipe $winningTeam a gagné !", style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
            onPressed: () {},
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  ///Method to display any message
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
