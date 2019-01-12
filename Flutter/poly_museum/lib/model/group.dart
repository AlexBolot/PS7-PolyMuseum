import 'package:cloud_firestore/cloud_firestore.dart';

class Group{

  String id;
  String groupeCode;
  bool isFinished;

  Group(this.id, this.groupeCode, this.isFinished);

  Group.fromMap(DocumentSnapshot snap) {
    id = snap.documentID;
    groupeCode = snap.data['groupeCode'];
    isFinished = snap.data['isFinished'];
  }

  Map<String, dynamic> toMap() {
    return {
      'groupeCode': groupeCode,
      'isFinished': isFinished,
    };
  }

}