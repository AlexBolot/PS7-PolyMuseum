import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poly_museum/model/plugin.dart';
import 'package:path_provider/path_provider.dart';


class PluginService {
  static StreamSubscription<QuerySnapshot> pluginsDataStream;
  static final Firestore _firestore = Firestore.instance;
  static final HttpClient httpClient = HttpClient();
  static List<Plugin> plugins = List();

  static streamGalleryItems(VoidCallback callback) async {
    pluginsDataStream = _firestore
        .collection("Musées")
        .document("NiceSport")
        .collection("plugins")
        .snapshots()
        .listen((groupData) async {
      plugins = List();
      for (DocumentSnapshot doc in groupData.documents) {
        DocumentSnapshot ref = await doc.data["ref"].get();
        plugins.add(new Plugin(ref.data["packageName"], ref.data["downloadURL"],
            ref.data["type"]));
      }
      callback();
    });
  }

  static Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  static disposeGalleryItemsStream() => pluginsDataStream?.cancel();
}
