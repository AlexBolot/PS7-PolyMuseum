import 'package:cloud_firestore/cloud_firestore.dart';

class Plugin {
  String qualifiedName;
  String downloadUrl;
  String type;
  String pluginName;
  String fullLocalPath;

  Plugin(this.qualifiedName, this.downloadUrl, this.type, this.pluginName);

  Plugin.fromSnapshot(DocumentSnapshot snap) {
    this.qualifiedName = snap.data['qualifiedName'];
    this.downloadUrl = snap.data['downloadURL'];
    this.pluginName = snap.data['pluginName'];
    this.type = snap.data['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': qualifiedName,
      'downloadUrl': downloadUrl,
      'pluginName': pluginName,
      'type': type,
    };
  }

  @override
  String toString() => '$qualifiedName -- $type -- $downloadUrl';
}
