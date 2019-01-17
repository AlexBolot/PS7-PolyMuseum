import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/group.dart';

class GroupService {
  StreamSubscription<QuerySnapshot> _groupsStream;
  List<Group> groups = [];

  List<int> get groupIDs => groups.map((group) => int.tryParse(group.id.replaceAll('groupe', ''))).toList();

  /// Method that allow to obtain a list of groups based on the database
  void streamGroups() {
    _groupsStream = museumReference.collection("GroupesVisite").snapshots().listen(
      (querySnapshot) {
        groups = querySnapshot.documents.map((snap) => Group.fromMap(snap)).toList();
      }
    );
  }

  /// Method that allow to stop listening to groupStream
  void dispose() => _groupsStream?.cancel();

  ///Method used to create a group
  ///param id : the id of the group that will be created
  ///param code : the code used to recognize the group (!= from id)
  ///return a Future.
  Future createGroup(int id, String code) async {
   await museumReference
        .collection("GroupesVisite")
        .document('$id')
        .setData({'groupeCode': code, 'isFinished': false, 'isStarted': false});
  }

  ///Method to add a member to a group
  ///param name : a string representation of the member's name
  ///param code : a string representation of the group's code
  Future addMemberToGroup(String name, String code) async {
    if (_groupsStream == null) {
      streamGroups();
    }

    Group group = groups.singleWhere((group) => group.groupeCode == code);

    await museumReference
        .collection("GroupesVisite")
        .document(group.id)
        .collection('Membres')
        .document()
        .setData({'prenom': name});
  }
}
