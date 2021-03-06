import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/objects.dart';
import 'package:poly_museum/proposal_view.dart';
import 'package:poly_museum/services/object_research_game_service.dart';
import 'package:poly_museum/services/service_provider.dart';

class ObjectResearchGameView extends StatefulWidget {
  @override
  _ObjectResearchGameViewState createState() => _ObjectResearchGameViewState();
}

class _ObjectResearchGameViewState extends State<ObjectResearchGameView> {
  File picture;
  bool loadingImage = false;
  String barcode = globalBarcode;
  String userGroup = globalUserGroup;
  String userTeam = globalUserTeam;
  String userName = globalUserName;
  String discover = "un membre de votre équipe";
  Duration gameDuration = null;

  ObjectResearchGameService gameService = ServiceProvider.gameService;

  _refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
    gameService.getTeammates(globalUserGroup);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameService.timerObject != null && gameService.gameStatusBegin && !gameService.hasAnsweredTimerObject) {
        displayObjectSentTeamMate();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Jeu de recherche d'objet")),
      body: Container(
        child: new ListView(children: displayGameElements()),
      ),
    );
  }

  ///Method to display game elements (description, winning teams etc)
  displayGameElements () {
    if (gameService.gameStatusEnd) {
      String winningTeam = gameService.winningTeam.toString();
      Card card = addNewCard("Partie terminée");
      Card card2;
      if (winningTeam == '-1') {
        card2 = addNewCard("Aucune équipe n'a remporté le jeu");
      } else {
        String winners = gameService.completeTeam[winningTeam].toString();
        if(winningTeam == globalUserTeam){
          card2 = addNewCard("Votre équipe a gagné ! Félicitations !");
        }else {
          card2 = addNewCard(
              "L'équipe vainqueur est l'équipe numéro $winningTeam, composé des membres $winners");
        }
      }



      if (gameService.gameStatusEnd) {
        gameService.fetchTimestamp(userGroup).then((future) {
          this.gameDuration = gameService.endTimestamp.difference(gameService.startTimestamp);

          _refresh();
        });
      }

      List<Widget> list = [];
      list.add(card);
      list.add(card2);

      if (gameDuration != null && gameService.gameStatusEnd) {
        String durationStr = gameDuration.toString().split(".")[0];
        Card card3 = addNewCard("La partie à durée $durationStr");
        list.add(card3);
      }

      return list;
    } else {
      if (gameService.gameStatusBegin) {
        return gameService.objectsGame.map((object) {
          bool foundTeam = false;
          return GestureDetector(
            onTap: () {
              for( dynamic v in object.userAndTeam){
                if (v["equipeID"] == (userTeam)) {
                  displayObjectAlreadyFound(object);
                  foundTeam = true;
                }
              }
              if(!foundTeam){
                scan(object);
                foundTeam = false;
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
        this.barcode = null;
        print('The user did not grant the camera permission!');
      } else {
        this.barcode = null;
        print('Unknown error: $e');
      }
    } on FormatException {
      this.barcode = null;
      print('null (User returned using the "back"-button before scanning anything. Result)' );
    } catch (e) {
      this.barcode = null;
      print('Unknown error: $e');
    }
    List membersTeams = [];
    var keyObject;
    var correctObjectFound = false;

    if(barcode == null) return;

    bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProposalView(barcode)));

    if (result != null && result == true) {if (object.qrCode == this.barcode) {
      //TODO put back here
      membersTeams.addAll(object.userAndTeam);
      membersTeams.add({"equipeID": userTeam, "membreID": globalUserID});
      /*objectFound = new List.from(object.userAndTeam.values);
      objectFound.add(this.userTeam);*/
      keyObject = object.dataBaseName;
      correctObjectFound = true;}
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
    for (dynamic v in object.userAndTeam) {
      if (object.userAndTeam.isNotEmpty && v["equipeID"] == (userTeam)) {
        color = Color.fromARGB(255, 50, 200, 50);
      }
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

  void displayObjectAlreadyFound(Objects object) async {
    String m = await gameService.getFoundObjectInfo(object, userGroup, userTeam);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(m),
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

  void displayObjectSentTeamMate() {
    if (picture == null && !loadingImage) {
      loadImage(gameService.timerObject.qrCode);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text(gameService.timerObject.description),
            content: displayImage(),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameService.updateTimerObjectResult(userGroup, globalUserTeam, userName, true);
                  },
                  child: Text(
                    'Je valide',
                    style: DefaultTextStyle.of(context).style.apply(color: Colors.green, fontSizeFactor: 0.5),
                  ),
                ),
              ),
              Center(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameService.updateTimerObjectResult(userGroup, globalUserTeam, userName, false);
                  },
                  child: Text(
                    'Je refuse',
                    style: DefaultTextStyle.of(context).style.apply(color: Colors.red[800], fontSizeFactor: 0.5),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
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

  void loadImage(String code) async {
    File file = await ServiceProvider.gameService.getImageFromCode(code);
    setState(() {
      picture = file;
      loadingImage = true;
    });
  }

  Widget displayImage() {
    double size = 300.0;
    if (picture != null && loadingImage) {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(16.0),
        child: Image.file(picture),
      );
    }
    return Container(
      width: size,
      height: size,
    );
  }
}
