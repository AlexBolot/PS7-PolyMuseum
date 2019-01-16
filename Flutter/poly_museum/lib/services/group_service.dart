import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/group.dart';

class GroupService {
  StreamSubscription<QuerySnapshot> _groupsStream;
  List<Group> groups = [];

  List<int> get groupIDs => groups.map((group) => int.tryParse(group.id.replaceAll('groupe', ''))).toList();

  void streamGroups() {
    _groupsStream = museumReference.collection("GroupesVisite").snapshots().listen(
      (querySnapshot) {
        groups = querySnapshot.documents.map((snap) => Group.fromMap(snap)).toList();
      }
    );
  }

  void dispose() => _groupsStream?.cancel();

  void createGroup(int id, String code) {
    museumReference
        .collection("GroupesVisite")
        .document('$id')
        .setData({'groupeCode': code, 'isFinished': false, 'isStarted': false});
  }

  void addMemberToGroup(String name, String code) {
    if (_groupsStream == null) {
      streamGroups();
    }

    Group group = groups.singleWhere((group) => group.groupeCode == code);

    museumReference
        .collection("GroupesVisite")
        .document(group.id)
        .collection('Membres')
        .document()
        .setData({'prenom': name});
  }
}
