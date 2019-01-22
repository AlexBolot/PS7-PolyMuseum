import 'package:cloud_firestore/cloud_firestore.dart';

class Plugin {
  String identifier;
  String qualifiedName;
  String downloadUrl;
  String type;
  String pluginName;
  String fullLocalPath;
  bool config = false;
  String libelle;
  String museum;
  
  Plugin(this.qualifiedName, this.downloadUrl, this.type, this.pluginName, this.config, this.libelle, [ this.museum ]) {
    this.identifier = libelle;
  }

  Plugin.fromSnapshot(DocumentSnapshot snap) {
    this.qualifiedName = snap.data['qualifiedName'];
    this.downloadUrl = snap.data['downloadUrl'];
    this.pluginName = snap.data['pluginName'];
    this.type = snap.data['type'];
    this.config = snap.data['config'];
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': qualifiedName,
      'downloadUrl': downloadUrl,
      'pluginName': pluginName,
      'type': type,
    };
  }

  bool isActivatedInMuseum(String museum) {
    return this.museum == museum;
  }

  String getIdentifier() {
    return identifier;
  }

  @override
  String toString() => '$qualifiedName -- $type -- $downloadUrl';
}
