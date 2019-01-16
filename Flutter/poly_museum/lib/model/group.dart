import 'package:cloud_firestore/cloud_firestore.dart';

class Group{

  String id;
  String groupeCode;
  bool isFinished;
  bool isStarted;

  Group(this.id, this.groupeCode, this.isFinished,this.isStarted);

  Group.fromMap(DocumentSnapshot snap) {
    id = snap.documentID;
    groupeCode = snap.data['groupeCode'];
    isFinished = snap.data['isFinished'];
    isStarted = snap.data['isStarted'];
  }

  Map<String, dynamic> toMap() {
    return {
      'groupeCode': groupeCode,
      'isFinished': isFinished,
      'isStarted' : isStarted,
    };
  }

}