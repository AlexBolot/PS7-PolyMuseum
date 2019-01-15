import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/model/plugin.dart';
import 'package:path_provider/path_provider.dart';

class PluginService {
  static final Firestore _firestore = Firestore.instance;
  static final HttpClient httpClient = HttpClient();
  static List<Plugin> plugins = List();

  streamPluginsData(VoidCallback callback) async {
    QuerySnapshot querySnapshot;
    querySnapshot = await _firestore.collection("Musées").document("NiceSport").collection("plugins2").getDocuments();

    for (DocumentSnapshot doc in querySnapshot.documents) {
      DocumentSnapshot ref = await doc.data["ref"].get();
      plugins.add(Plugin.fromSnapshot(ref));
    }

    callback();
  }

  static Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$filename');

    File file2 = new File('$dir/test.json');

    await file2.writeAsString('{"test" : []}');
    await file.writeAsBytes(bytes);
    return file;
  }

  static initPlugins() async {
    for (Plugin plugin in plugins) {
      File file = await PluginService.downloadFile(plugin.downloadUrl, plugin.pluginName);
      plugin.fullLocalPath = file.path;
    }

    final channel = const MethodChannel('channel:polytech.al.imh/plugin');

    Map<String, List<String>> map = {
      'paths': plugins.map((p) => p.fullLocalPath).toList(),
      'types': plugins.map((p) => p.type).toList(),
      'qualifiedClassNames': plugins.map((p) => p.qualifiedName).toList(),
      'pluginNames': plugins.map((p) => p.type).toList(),
    };

    await channel.invokeMethod('loadPlugins', map);

    var res = await channel.invokeMethod('processThemePlugins');

    print(res);
  }


}
