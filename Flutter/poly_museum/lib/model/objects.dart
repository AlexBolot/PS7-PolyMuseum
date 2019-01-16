import 'package:cloud_firestore/cloud_firestore.dart';

class Objects{

  DocumentReference descriptionReference;
  String description;
  String qrCode;
  List discoveredByTeams = new List();
  String dataBaseName;

  Objects(this.descriptionReference, this.description, this.qrCode,this.discoveredByTeams,this.dataBaseName);

  @override
  String toString() => '$descriptionReference -- $description -- $qrCode -- $discoveredByTeams -- $dataBaseName';
}