import 'package:cloud_firestore/cloud_firestore.dart';

class Objects {
  DocumentReference descriptionReference;
  String description;
  String qrCode;
  List userAndTeam = [];
  String dataBaseName;
  String downloadUrl;
  String name;

  Objects(this.descriptionReference, this.description, this.qrCode, this.downloadUrl, this.userAndTeam, this.dataBaseName,this.name);


  @override
  String toString() =>
      '$descriptionReference -- $description -- $qrCode -- $dataBaseName';
}