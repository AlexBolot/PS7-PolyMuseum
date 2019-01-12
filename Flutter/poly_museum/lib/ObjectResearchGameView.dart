import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/ObjectResearchGameService.dart';
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
    build(context);
  }

  @override
  void dispose() {
    super.dispose();
    ObjectResearchGameService.disposeObjectsDiscoveredStream();
  }


    @override
  Widget build(BuildContext context) {
    //print(ObjectResearchGameService.objectsDiscovered);
    return Scaffold(
      appBar: AppBar(title: Text('Descriptions View')),
      //return Card(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("Musées")
              .document("NiceSport")
              .collection("Objets")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Container();
              default:
                return new ListView(children: getExpenseItems(snapshot));
            }
          },
        ),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((descr) {
      return GestureDetector(
        onTap: () {
          scan(descr["description"]);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 38.0, vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              descr["description"],
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          color: chooseColor(descr["description"]),
        ),
      );
    }).toList();
  }

  Future scan(objectDescription) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this.barcode = 'The user did not grant the camera permission!';
      } else {
        this.barcode = 'Unknown error: $e';
        //print(e);
      }
    } on FormatException {
      this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
      //print('Unknown error: $e');
    }
    final DocumentReference postRef = Firestore.instance
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Objets");

    List objectFound;
    var keyObject;
    var descriptionObject;
    var correctObjectFound = false;

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        void iterateMapEntry(key, value) {
          postSnapshot.data[key] = value;
          value["descriptionRef"].get().then((objet) {
            if (objet["barCode"] == this.barcode &&
                objectDescription == objet["description"]) {
              descriptionObject = value["descriptionRef"];
              objectFound = value["trouveParEquipes"].toList();
              objectFound.add(this.userTeam);
              keyObject = key;
              correctObjectFound = true;
            }
          });
        }

        postSnapshot.data.forEach(iterateMapEntry);
      }
    });

    Future.delayed(new Duration(seconds: 1), () {
      if (correctObjectFound) {
        final DocumentReference postRef = Firestore.instance
            .collection("Musées")
            .document("NiceSport")
            .collection("GroupesVisite")
            .document("groupe$userGroup")
            .collection("JeuRechercheObjet")
            .document("Objets");
        Firestore.instance.runTransaction((Transaction tx) async {
          await tx.update(postRef, <String, dynamic>{
            keyObject: {
              'descriptionRef': descriptionObject,
              'trouveParEquipes': objectFound
            }
          });
        });
      }
    });
  }

  chooseColor(object) {
    var color = Color.fromARGB(255, 255, 255, 255);
    if (ObjectResearchGameService.objectsDiscovered[object] != null && ObjectResearchGameService.objectsDiscovered[object].contains(userTeam)) {
      color = Color.fromARGB(255, 50, 200, 50);
    }
      return color;
  }
}
