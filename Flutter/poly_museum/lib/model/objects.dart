import 'package:cloud_firestore/cloud_firestore.dart';

class Objects {
  DocumentReference descriptionReference;
  String description;
  String qrCode;
  List discoveredByTeams = new List();
  String dataBaseName;
  String downloadUrl;

  Objects(this.descriptionReference, this.description, this.qrCode, this.downloadUrl, this.discoveredByTeams, this.dataBaseName);

  @override
  String toString() => '$descriptionReference -- $description -- $qrCode -- $discoveredByTeams -- $dataBaseName';
}
