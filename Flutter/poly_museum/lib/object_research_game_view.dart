import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/objects.dart';
import 'package:poly_museum/services/object_research_game_service.dart';
import 'package:poly_museum/services/service_provider.dart';

class ObjectResearchGameView extends StatefulWidget {
  @override
  _ObjectResearchGameViewState createState() => _ObjectResearchGameViewState();
}

class _ObjectResearchGameViewState extends State<ObjectResearchGameView> {
  String barcode = globalBarcode;
  String userGroup = globalUserGroup;
  String userTeam = globalUserTeam;
  String userName = globalUserName;
  String discover = "un membre de votre équipe";
  ObjectResearchGameService gameService = ServiceProvider.gameService;

  VoidCallback _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    gameService.updateResearchGameDescriptions(_refresh, userGroup);
    gameService.updateGameStatus(_refresh, userGroup);
    //gameService.getFoundObjectInfo(, userGroup, userTeam, _refresh)
  }

  @override
  void dispose() {
    super.dispose();
    gameService.disposeObjectsDiscoveredStream();
    gameService.disposeGameStatusStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Descriptions View')),
      body: Container(
        child: new ListView(children: displayGameElements()),
      ),
    );
  }

  ///Method to display game elements (description, winning teams etc)
  displayGameElements() {
    if (gameService.gameStatusEnd) {
      String winningTeam = gameService.winningTeam.toString();
      Card card = addNewCard("Partie terminée");
      Card card2;
      if (winningTeam == '-1') {
        card2 = addNewCard("Aucune équipe n'a remporté le jeu");
      } else {
        card2 =
            addNewCard("L'équipe vainqueur est l'équipe numéro $winningTeam");
      }

      List<Widget> list = [];
      list.add(card);
      list.add(card2);
      return list;
    } else {
      if (gameService.gameStatusBegin) {
        return gameService.objectsGame.map((object) {
          return GestureDetector(
            onTap: () {
              if (object.userAndTeam.values.contains(userTeam)) {
                displayObjectAlreadyFound(object);
              } else {
                scan(object);
              }
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 38.0, vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  object.description,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              color: chooseColor(object),
            ),
          );
        }).toList();
      } else {
        Card card = addNewCard("Attendez le début de la partie...");
        List<Widget> list = [];
        list.add(card);
        return list;
      }
    }
  }

  /// Method to scan QRCOde, called when a description is pressed.
  Future scan(Objects object) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this.barcode = 'The user did not grant the camera permission!';
      } else {
        this.barcode = 'Unknown error: $e';
      }
    } on FormatException {
      this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
    Map membersTeams;
    var keyObject;
    var correctObjectFound = false;

    if (object.qrCode == this.barcode) {
      membersTeams = new Map.from(object.userAndTeam);
      membersTeams.putIfAbsent(userName, () => userTeam);
      /*objectFound = new List.from(object.userAndTeam.values);
      objectFound.add(this.userTeam);*/
      keyObject = object.dataBaseName;
      correctObjectFound = true;
    }

    Future.delayed(new Duration(seconds: 1), () {
      if (correctObjectFound) {
        gameService.teamFoundObject(userGroup, keyObject,
            object.descriptionReference, membersTeams);
      }
      displayResult(correctObjectFound);
    });
  }

  ///Method used to change the color of a description when a object is found
  chooseColor(Objects object) {
    var color = Color.fromARGB(255, 255, 255, 255);
    if (object.userAndTeam.isNotEmpty &&
        object.userAndTeam.values.contains(userTeam)) {
      color = Color.fromARGB(255, 50, 200, 50);
    }
    return color;
  }

  void displayResult(bool result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(textResult(result)),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Retour'),
            )
          ],
        );
      },
    );
  }

  void displayObjectAlreadyFound(Objects object) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(gameService.getFoundObjectInfo(
          object, userGroup, userTeam, _refresh)),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Retour'),
            )
          ],
        );
      },
    );
  }

  Card addNewCard(String text) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 38.0, vertical: 4.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  String textResult(result) {
    return result
        ? "Bonne réponse ! Vous avez trouvé"
        : "Mauvaise réponse ! Continuez de chercher";
  }
}
