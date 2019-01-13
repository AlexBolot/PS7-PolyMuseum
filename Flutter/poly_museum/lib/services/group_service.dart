import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/model/group.dart';

class GroupService {
  Firestore _firestore = Firestore.instance;

  static StreamSubscription<QuerySnapshot> _groupsStream;

  static List<Group> _groups = [];

  List<Group> get groups => _groups;

  List<int> get groupIDs => _groups.map((group) => int.tryParse(group.id.replaceAll('groupe', '')));

  streamGroups() {
    _groupsStream = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .snapshots()
        .listen((querySnapshot) {
      _groups = [];

      for (DocumentSnapshot snap in querySnapshot.documents) {
        _groups.add(Group.fromMap(snap));
      }
    });
  }

  dispose() => _groupsStream?.cancel();

  createGroup(int id, String code) {
    _firestore.collection("Musées").document("NiceSport").collection("GroupesVisite").document('$id').setData({
      'groupeCode': code,
      'isFinished': false,
    });
  }

  addMemberToGroup(String name, String code) {
    if (_groupsStream == null) {
      streamGroups();
    }

    Group group = groups.singleWhere((group) => group.groupeCode == code);

    _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("GroupesVisite")
        .document(group.id)
        .collection('Membres')
        .document()
        .setData({'prenom': name});
  }
}
