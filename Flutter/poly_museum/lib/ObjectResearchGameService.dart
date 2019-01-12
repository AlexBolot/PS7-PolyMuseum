import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class ObjectResearchGameService {
  static StreamSubscription<QuerySnapshot> objectsDiscoveredStream;
  static final Firestore _firestore = Firestore.instance;

  static Map<String, List> objectsDiscovered = Map();


  static updateResearchGameDescriptions(VoidCallback callback,userGroup, userTeam) {
     objectsDiscoveredStream  = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document("groupe$userGroup")
        .collection("JeuRechercheObjet")
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        //objectsDiscovered = Map();

        if (doc.data.keys.contains("objet1")) {
          void iterateMapEntry(key, value) {
            doc.data[key] = value;
            value["descriptionRef"].get().then((string) {
              List teamFoundObject = value['trouveParEquipes'];
              objectsDiscovered.putIfAbsent(
                  string["description"], () => teamFoundObject);
            });
          }

          doc.data.forEach(iterateMapEntry);
        }
      });
      callback();
    });
  }

  static disposeObjectsDiscoveredStream() => objectsDiscoveredStream?.cancel();
}
