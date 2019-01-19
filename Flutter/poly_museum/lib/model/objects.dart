import 'package:cloud_firestore/cloud_firestore.dart';

class Objects {
  DocumentReference descriptionReference;
  String description;
  String qrCode;
  Map<String, String> userAndTeam = new Map();
  String dataBaseName;
  String name;

  Objects(this.descriptionReference, this.description, this.qrCode,
      this.userAndTeam, this.dataBaseName, this.name);

  @override
  String toString() =>
      '$descriptionReference -- $description -- $qrCode -- $dataBaseName';
}
