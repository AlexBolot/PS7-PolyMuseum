import 'package:flutter/material.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/game.dart';
import 'package:poly_museum/services/group_service.dart';
import 'package:poly_museum/services/object_research_game_service.dart';

class GameGuideView extends StatefulWidget {
  final String title;

  GameGuideView({Key key, this.title}) : super(key: key);

  @override
  _GameGuideViewState createState() => _GameGuideViewState();
}

class _GameGuideViewState extends State<GameGuideView> {
  GroupService groupService = GroupService();
  Game game;
  String code = currentGroupID;

  @override
  void initState() {
    super.initState();
    ObjectResearchGameService.getTeams(_refresh, currentGroupID);
    ObjectResearchGameService.updateResearchGameDescriptions(
        _refresh, globalUserGroup, globalUserTeam);
  }

  VoidCallback _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    ObjectResearchGameService.disposeObjectsDiscoveredStream();
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
          child: Text('Arrêter le jeu',
              style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
          onPressed: () async {
            ObjectResearchGameService.endGame(_refresh, currentGroupID);
            displayMessage("Fin du jeu.");
          },
        ),
      ),
    ));
    Map<int, String> map = new Map();
    for (String s in ObjectResearchGameService.teamsGame) {
      List t = s.split(":");
      map.update(
          int.parse(t[0]), (String) => map[int.parse(t[0])] + ", " + t[1],
          ifAbsent: () => t[1]);
    }
    for (int i in map.keys) {
      list.add(Card(
        margin: EdgeInsets.all(16.0),
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: ListTile(
            title: Text('Equipe ' + i.toString(),
                style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
            subtitle: Text(map[i]),
          ),
        ),
      ));
    }
    list.add(displayEndGame());
    return list;
  }

  Widget displayEndGame(){
    if(ObjectResearchGameService.winningTeam != -1){
      String winningTeam = ObjectResearchGameService.winningTeam.toString();
      return Card(
        margin: EdgeInsets.all(16.0),
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: FlatButton(
            child: Text("L'équipe $winningTeam a gagné !",
                style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
          ),
        ),
      );
    }else{
      return Container();
    }
  }
  //Pour les objets : les récupérer tous, avec leur param trouvé par, et si une des équipes est dans tous les trouvé par on le signale au guide

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
