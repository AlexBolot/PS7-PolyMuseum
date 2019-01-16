import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/objects.dart';

class ObjectResearchGameService {
  StreamSubscription<QuerySnapshot> _objectsDiscoveredStream;
  StreamSubscription<DocumentSnapshot> _gameStatusStream;
  StreamSubscription<DocumentSnapshot> _teamsStream;

  List<String> teamsGame = [];
  List<Objects> objectsGame = [];
  Map<Object, List<int>> objectsteams = {};
  int numberTeams;
  int winningTeam = -1;

  bool _gameStatusBegin;
  bool _gameStatusEnd;

  bool get gameStatusBegin => _gameStatusBegin ?? false;

  bool get gameStatusEnd => _gameStatusEnd ?? false;

  void updateGameStatus(VoidCallback callback, userGroup) {
    _gameStatusStream = museumReference.collection("GroupesVisite").document("groupe$userGroup").snapshots().listen(
      (groupData) {
        _gameStatusBegin = groupData.data["isStarted"];
        _gameStatusEnd = groupData.data["isFinished"];
        callback();
      },
    );
  }

  void startGame(VoidCallback callback, userGroup) {
    museumReference.collection("GroupesVisite").document("groupe$userGroup").updateData({
      'isFinished': false,
      'isStarted': true,
    });
  }

  void endGame(VoidCallback callback, userGroup) {
    museumReference.collection("GroupesVisite").document("groupe$userGroup").updateData({
      'isFinished': true,
      'isStarted': false,
    });
  }

  void updateResearchGameDescriptions(VoidCallback callback, userGroup, userTeam) {
    _objectsDiscoveredStream = museumReference
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
                value["descriptionRef"], ref.data["description"], ref.data["barCode"], teamFoundObject, key));
          }

          for (String s in doc.data.keys) {
            await iterateMapEntry(s, doc.data[s]);
          }
        }
      }
      if (numberTeams != null) {
        winningTeam = checkEndGame();
      }
      callback();
    });
    getTeamNumber(userGroup);
  }

  void teamFoundObject(userGroup, keyObject, description, List teamFoundObject) {
    museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Objets")
        .updateData({'descriptionRef': description, 'trouveParEquipes': teamFoundObject});
  }

  void getTeamNumber(userGroup) {
    StreamSubscription<DocumentSnapshot> teams;
    teams = museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snap) {
      numberTeams = snap.data.length;
    });
  }

  int checkEndGame() {
    int nbObjects = objectsGame.length;
    for (int i = 0; i < numberTeams; i++) {
      int nbObjetsParEquipe = 0;
      for (Objects o in objectsGame) {
        if (o.discoveredByTeams.contains(i.toString())) {
          nbObjetsParEquipe++;
        }
        if (nbObjects == nbObjetsParEquipe) {
          return i;
        }
      }
    }
    return -1;
  }

  void getTeams(VoidCallback callback, userGroup) {
    _teamsStream = museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snap) async {
      teamsGame = [];
      for (String s in snap.data.keys) {
        for (DocumentReference d in snap.data[s]["membres"]) {
          String prenom = ((await d.get())["prenom"]);
          teamsGame.add("$s:$prenom");
        }
      }

      callback();
    });
  }

  void disposeObjectsDiscoveredStream() => _objectsDiscoveredStream?.cancel();

  void disposeGameStatusStream() => _gameStatusStream?.cancel();

  void disposeTeamsStream() => _teamsStream?.cancel();
}
