import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/objects.dart';
import 'package:poly_museum/test_class.dart';

class ObjectResearchGameService {
  final HttpClient _httpClient = HttpClient();

  StreamSubscription<QuerySnapshot> _objectsDiscoveredStream;
  StreamSubscription<DocumentSnapshot> _gameStatusStream;
  StreamSubscription<DocumentSnapshot> _teamsStream;
  StreamSubscription<DocumentSnapshot> _timerObjectsStream;

  List<String> teammates = [];
  List<String> teamsGame = [];
  List<Objects> objectsGame = [];
  Map<Object, List<int>> objectsteams = {};
  int numberTeams;
  int winningTeam = -1;
  Objects timerObject;
  bool hasAnsweredTimerObject = false;
  dynamic answerTimerObject;

  bool _gameStatusBegin;
  bool _gameStatusEnd;

  bool get gameStatusBegin => _gameStatusBegin ?? false;

  bool get gameStatusEnd => _gameStatusEnd ?? false;

  DateTime _startDateTime = null;
  DateTime _endDateTime = null;

  Duration get gameDuration => _gameStatusEnd ? _endDateTime.difference(_startDateTime) : null;

  ///
  /// This method streams the values from game status, whether it is began or finished
  /// (isStarted and isFinished in the Database) corresponding to the right userGroup
  ///
  void updateGameStatus(VoidCallback callback, userGroup) {
    _gameStatusStream = museumReference.collection("GroupesVisite").document("groupe$userGroup").snapshots().listen(
      (groupData) {
        _gameStatusBegin = groupData.data["isStarted"];
        _gameStatusEnd = groupData.data["isFinished"];
        callback();
      },
    );
  }

  ///
  /// Indicates a game has begun in the corresponding userGroup
  ///
  void startGame(VoidCallback callback, userGroup) async {
    await museumReference.collection("GroupesVisite").document("groupe$userGroup").updateData({
      'isFinished': false,
      'isStarted': true,
    });

    _startDateTime = new DateTime.now();
  }

  ///
  /// Indicates a game is finished in the corresponding userGroup
  ///
  void endGame(VoidCallback callback, userGroup) async {
    await museumReference.collection("GroupesVisite").document("groupe$userGroup").updateData({
      'isFinished': true,
      'isStarted': false,
    });

    _endDateTime = new DateTime.now();
  }

  ///
  /// Streams the objects corresponding to the object Research Game.
  /// When a team has found an object in the game it's updated in the @objectsGame list
  /// The stream is set in function of the userGroup
  ///
  void updateResearchGameDescriptions(VoidCallback callback, userGroup) {
    _objectsDiscoveredStream = museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .snapshots()
        .listen((data) async {
      objectsGame = List();
      for (DocumentSnapshot doc in data.documents) {
        // The if statement below ensures that we get the elements from the "Object" documents,
        // to add the right objects in @objectGame list and not something else.
        // Problem : if the "objet1" is deleted from the DB, the list can't add anything
        if (doc.data.keys.contains("objet1")) {
          Future iterateMapEntry(key, value) async {
            doc.data[key] = value;
            DocumentSnapshot ref = await value["descriptionRef"].get();
            List teamFoundObject = value['trouveParEquipes'];
            objectsGame.add(new Objects(
              value["descriptionRef"],
              ref.data["description"],
              ref.data["barCode"],
              ref.data['downloadUrl'],
              teamFoundObject,
              key,
            ));
          }

          for (String s in doc.data.keys) {
            await iterateMapEntry(s, doc.data[s]);
          }
        }
      }
      if (numberTeams != null) {
        winningTeam = checkEndGame();
      }
      getTimerObject(userGroup, () {});
      callback();
    });
  }

  ///
  /// Updates the database when a team have found an object in the game
  /// It adds the teams number in the list of teams that have found the correct object
  ///
  void teamFoundObject(userGroup, keyObject, description, List teamFoundObject) {
    museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Objets")
        .updateData({
      keyObject: {'descriptionRef': description, 'trouveParEquipes': teamFoundObject}
    });
  }

  ///
  /// When a visitor receives an object to validate or not coming from another teammate
  /// He can choose to validate or not the object presented with the description
  ///
  void updateTimerObjectResult(userGroup, teamNumber, userName, bool userResponse) {
    hasAnsweredTimerObject = true;
    answerTimerObject[teamNumber]["timerObjects"]["members"][userName] = userResponse;
    museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .updateData(answerTimerObject);
  }

  ///
  /// Gets the object sent by a visitor present in the same group
  /// Also Updates the number of teams present in the game
  ///
  void getTimerObject(userGroup, VoidCallback callback) {
    _timerObjectsStream = museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snap) {
      timerObject = null;
      numberTeams = snap.data.length;
      for (String s in snap.data.keys) {
        for (Objects ob in objectsGame) {
          if (snap.data[s]["timerObjects"]["objectRef"] == ob.descriptionReference &&
              snap.data[s]["timerObjects"]["members"].length > 0 &&
              snap.data[s]["timerObjects"]["members"].keys.contains(globalUserName) &&
              s == globalUserTeam) {
            timerObject = ob;
            answerTimerObject = {s: snap.data[s]};
          }
          if (snap.data[s]["timerObjects"]["members"].length > 0 && !snap.data[s]["timerObjects"]["members"].keys.contains(globalUserName)) {
            hasAnsweredTimerObject = false;
          }
        }
      }
      callback();
    });
  }

  /// Method to check if a game is over
  /// Checking if for each object a team has found them all
  /// return the id of the team if one has won, -1 else
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

  ///
  /// Add in the list teamsGame all the teams formed for a game.
  ///
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

  Future<File> getImageFromCode(String code) async {
    QuerySnapshot querySnapshot = await museumReference.collection('Objets').getDocuments();

    for (DocumentSnapshot doc in querySnapshot.documents) {
      if (doc.data['barCode'] == code) {
        var request = await _httpClient.getUrl(Uri.parse(doc.data['downloadUrl']));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        String dir = (await getTemporaryDirectory()).path;
        File file = new File('$dir/$code');

        return await file.writeAsBytes(bytes);
      }
    }

    return null;
  }

  Future<List<String>> getTeammates(String userGroup) async {
    DocumentSnapshot snapshot = await museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .get();

    teammates = [];

    for (DocumentReference doc in snapshot.data[globalUserTeam]['membres'].cast<DocumentReference>()) {
      DocumentSnapshot snap = await doc.get();
      teammates.add(snap.data['prenom']);
    }

    teammates.removeWhere((name) => name == globalUserName);

    return teammates;
  }

  Future addTimerObject(String userGroup, String code) async {
    DocumentSnapshot snapshot = await museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .get();

    Map memberChoices = {};
    DocumentReference objectRef;

    for (String name in teammates) {
      memberChoices.putIfAbsent(name, () => null);
    }

    for (DocumentSnapshot doc in (await museumReference.collection('Objets').getDocuments()).documents) {
      if (doc.data['barCode'] == code) {
        objectRef = doc.reference;
      }
    }

    await museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .updateData({
      globalUserTeam: {
        'membres': snapshot.data[globalUserTeam]['membres'],
        'timerObjects': {
          'members': memberChoices,
          'objectRef': objectRef,
        }
      }
    });
  }

  void listenTimerObjectReply(String userGroup, Function(Map) callback) {
    museumReference
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .document("Equipes")
        .snapshots()
        .listen((snapshot) {
          var timerObjects = snapshot.data[globalUserTeam]['timerObjects'] ?? {};
          var members = timerObjects['members'] ?? {};
      Map<String, bool> map = (members ?? {}).cast<String, bool>();
      callback(map);
    });
  }

  void disposeObjectsDiscoveredStream() => _objectsDiscoveredStream?.cancel();

  void disposeGameStatusStream() => _gameStatusStream?.cancel();

  void disposeTeamsStream() => _teamsStream?.cancel();

  void disposeTimerObjectsStream() => _timerObjectsStream?.cancel();

  testGameService() {
    changeMuseumTarget("NiceTest");

    TestCase(
      name: "Update Game Description",
      body: () {
        changeMuseumTarget("NiceTest");
        TestCase.assertTrue(objectsGame.length == 0);
        updateResearchGameDescriptions(() async {
          TestCase.assertTrue(objectsGame.length == 2);
          changeMuseumTarget("NiceSport");
          disposeGameStatusStream();
        }, globalUserGroup);
      },
    ).start();

    TestCase(
      name: "Get Team Number",
      body: () async {
        getTimerObject("1", () {
          TestCase.assertSame(numberTeams, 3);
        });
      },
    ).start();

    TestCase(
      name: "Get Teams",
      body: () async {
        TestCase.assertTrue(teamsGame.isEmpty);
        getTeams(() {
          TestCase.assertFalse(teamsGame.isEmpty);
        }, "1");
      },
    ).start();

    TestCase(
      name: "Starting Game",
      body: () async {
        TestCase.assertFalse(gameStatusEnd);
        TestCase.assertFalse(gameStatusBegin);
        startGame(() {
          TestCase.assertTrue(gameStatusBegin);
        }, 1);
        endGame(() {
          TestCase.assertTrue(gameStatusEnd);
        }, 1);
      },
    ).start();
  }
}
