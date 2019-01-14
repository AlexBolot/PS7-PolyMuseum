import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/ObjectResearchGameService.dart';
import 'package:poly_museum/Objects.dart';
//import 'package:qr_scanner_generator/scan.dart';

class ObjectResearchGameView extends StatefulWidget {
  @override
  _ObjectResearchGameViewState createState() => _ObjectResearchGameViewState();
}

class _ObjectResearchGameViewState extends State<ObjectResearchGameView> {

  String barcode = "";
  String userGroup = "1";
  String userTeam = "1";
  String userName = "Paul";


  VoidCallback _refresh() {
    setState(() {});

  }

  @override
  void initState() {
    super.initState();
    ObjectResearchGameService.updateResearchGameDescriptions(_refresh,userGroup,userTeam);
  }

  @override
  void dispose() {
    super.dispose();
    ObjectResearchGameService.disposeObjectsDiscoveredStream();
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Descriptions View')),
      body: Container(
        child: new ListView(children: getExpenseItems()),
      ),
    );
  }

  getExpenseItems() {
    return ObjectResearchGameService.objectsGame.map((object) {
      return GestureDetector(
        onTap: () {
          if (object.discoveredByTeams.contains(userGroup)) {
            displayObjectAlreadyFound();
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
  }

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
    List objectFound;
    var keyObject;
    var correctObjectFound = false;

    if (object.qrCode == this.barcode) {

      objectFound = new List.from(object.discoveredByTeams);
      objectFound.add(this.userTeam);
      keyObject = object.dataBaseName;
      correctObjectFound = true;

    }


    Future.delayed(new Duration(seconds: 1), () {
      if (correctObjectFound) {
        ObjectResearchGameService.teamFoundObject(userGroup,keyObject,object.descriptionReference,objectFound);
      }
      displayResult(correctObjectFound);
    });

  }

  chooseColor(Objects object) {
    var color = Color.fromARGB(255, 255, 255, 255);
    if ( object.discoveredByTeams != null && object.discoveredByTeams.contains(userTeam)) {
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

  void displayObjectAlreadyFound() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("L'objet sélectionné à déjà été trouvé par un coéquipier !"),
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

  String textResult(result){
    if(result == true){
      return "Bonne réponse ! Vous avez trouvé";
    }else{
      return "Mauvaise réponse ! Continuez de chercher";
    }
  }
}
