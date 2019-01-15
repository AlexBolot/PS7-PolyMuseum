import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/model/objects.dart';

class ObjectResearchGameService {
  static StreamSubscription<QuerySnapshot> objectsDiscoveredStream;
  static StreamSubscription<DocumentSnapshot> gameStatusStream;

  static final Firestore _firestore = Firestore.instance;

  static List<Objects> objectsGame = List();
  static bool gameStatusBegin;
  static bool gameStatusEnd;
  static Map<Object, List<int>> objectsteams = new Map();

  static updateGameStatus(VoidCallback callback, userGroup) {
    gameStatusStream = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .snapshots()
        .listen((groupData) {
      gameStatusBegin = groupData.data["isStarted"];
      gameStatusEnd = groupData.data["isFinished"];
      callback();
    });
  }

  static startGame(VoidCallback callback, userGroup) {
    Future.delayed(new Duration(seconds: 1), () {
      final DocumentReference postRef = Firestore.instance
          .collection("Musées")
          .document("NiceSport")
          .collection("GroupesVisite")
          .document("groupe$userGroup");
      Map<String, dynamic> m = new Map();
      m.update('isStarted', (bool) => true, ifAbsent: () => true);
      postRef.updateData(m);
    });
  }

  static endGame(VoidCallback callback, userGroup) {
    Future.delayed(new Duration(seconds: 1), () {
      final DocumentReference postRef = Firestore.instance
          .collection("Musées")
          .document("NiceSport")
          .collection("GroupesVisite")
          .document("groupe$userGroup");
      Map<String, dynamic> m = new Map();
      m.update('isFinished', (bool) => true, ifAbsent: () => true);
      postRef.updateData(m);
    });
  }

  static List<String> teamsGame = List();

  static updateResearchGameDescriptions(
      VoidCallback callback, userGroup, userTeam) {
    objectsDiscoveredStream = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .snapshots()
        .listen((data) async {
      objectsGame = List();
      for (DocumentSnapshot doc in data.documents) {
        if (doc.data.keys.contains("objet1")) {
          Future iterateMapEntry(key, value) async {
            doc.data[key] = value;
            DocumentSnapshot ref = await value["descriptionRef"].get();
            List teamFoundObject = value['trouveParEquipes'];
            objectsGame.add(new Objects(
                value["descriptionRef"],
                ref.data["description"],
                ref.data["barCode"],
                teamFoundObject,
                key));
          }

          for (String s in doc.data.keys) {
            await iterateMapEntry(s, doc.data[s]);
          }
        }
      }
      callback();
    });
  }

  static teamFoundObject(
      userGroup, keyObject, description, List teamFoundObject) {
    Future.delayed(new Duration(seconds: 1), () {
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
            'descriptionRef': description,
            'trouveParEquipes': teamFoundObject
          }
        });
      });
      //TODO getEndGame renvoie -1 si aucune équipe n'a fini et le numéro de l'équipe sinon <3
      //TODO Bon courage Dodo l'escargot
      int i = getEndGame(userGroup);
      print(i);
    });
  }

  static getEndGame(userGroup) {
    int nbEquipes;
    StreamSubscription<DocumentSnapshot> teams;
    teams = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snap) async {
      nbEquipes = snap.data.length;
      for (Objects o in objectsGame) {
        int nbObjets = objectsGame.length;
        for (int i = 0; i < nbEquipes; i++) {
          int nbObjetsParEquipe = 0;
          if (o.discoveredByTeams.contains(i)) {
            nbObjetsParEquipe++;
          }
          if (nbObjets == nbObjetsParEquipe) {
            return i;
          }
        }
      }
      return -1;
    });
  }

  static getTeams(VoidCallback callback, userGroup) {
    List t = new List<String>();
    StreamSubscription<DocumentSnapshot> teams;
    teams = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snap) async {
      teamsGame = List();
      for (String s in snap.data.keys) {
        for (DocumentReference d in snap.data[s]["membres"]) {
          String prenom = ((await d.get())["prenom"]);
          teamsGame.add("$s:$prenom");
        }
      }
      callback();
    });
    return teamsGame;
  }

  static disposeObjectsDiscoveredStream() => objectsDiscoveredStream?.cancel();

  static disposeGameStatusStream() => gameStatusStream?.cancel();
}
