import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/Objects.dart';

class ObjectResearchGameService {
  static StreamSubscription<QuerySnapshot> objectsDiscoveredStream;
  static final Firestore _firestore = Firestore.instance;

  static List<Objects> objectsGame = List();

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
      for(DocumentSnapshot doc in data.documents){
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
          for(String s in doc.data.keys){
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
    });
  }


  static disposeObjectsDiscoveredStream() => objectsDiscoveredStream?.cancel();
}
