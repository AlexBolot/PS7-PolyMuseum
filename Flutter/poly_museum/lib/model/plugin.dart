import 'package:cloud_firestore/cloud_firestore.dart';

class Plugin {
  String packageName;
  String downloadUrl;
  String type;

  Plugin(this.packageName, this.downloadUrl, this.type);

  Plugin.fromSnapshot(DocumentSnapshot snap) {
    this.packageName = snap.data['packageName'];
    this.downloadUrl = snap.data['downloadUrl'];
    this.type = snap.data['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'downloadUrl': downloadUrl,
      'type': type,
    };
  }

  @override
  String toString() => '$packageName -- $type -- $downloadUrl';
}
