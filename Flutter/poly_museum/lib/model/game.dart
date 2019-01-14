import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Game {
  String id;
  String groupeCode;
  List teams;
  List objets;

  Game(this.groupeCode);

  Game.fromMap(DocumentSnapshot snap) {
    id = snap.documentID;
    groupeCode = snap.data['groupeCode'];
   // teams = getTeams();
  }

  Map<String, dynamic> toMap() {
    return {
      'groupeCode': groupeCode,
    };
  }

  List getTeams() {
    StreamBuilder<QuerySnapshot> streamBuilder = new StreamBuilder(
        stream: Firestore.instance.collection("JeuRechercheObjets").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        });
  }
}
