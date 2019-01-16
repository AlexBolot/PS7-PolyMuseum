import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/model/plugin.dart';
import 'package:path_provider/path_provider.dart';

class PluginService {
  static const MethodChannel _pluginChannel = const MethodChannel('channel:polytech.al.imh/plugin');
  static final Firestore _firestore = Firestore.instance;
  static final HttpClient httpClient = HttpClient();
  static List<Plugin> plugins = List();
  static Map<String, Map<String, dynamic>> configs = {};

  static DocumentReference configRef;

  Future streamConfig() async {
    configRef.snapshots().listen((snap) async {
      DocumentSnapshot config = await configRef.get();

      Map<String, dynamic> configMap = {};

      for (String key in config.data.keys) {
        configMap.putIfAbsent(key, () => config.data[key]);
      }

      configs.putIfAbsent("THEME_PLUGIN", () => configMap);

      await _pluginChannel.invokeMethod('addConfigs', configs);
      await processThemePlugins();
    });
  }

  Future streamPluginsData() async {
    QuerySnapshot querySnapshot;
    querySnapshot = await _firestore.collection("Musées").document("NiceSport").collection("plugins").getDocuments();

    for (DocumentSnapshot doc in querySnapshot.documents) {
      // Getting plugin file

      if(doc.data["activated"] == "false") continue;

      DocumentSnapshot ref = await doc.data["ref"].get();
      var plugin = Plugin.fromSnapshot(ref);
      plugins.add(plugin);

      // Getting plugin config

      configRef = doc.reference.collection('config').document('current');
      DocumentSnapshot config = await configRef.get();

      Map<String, dynamic> configMap = {};

      for (String key in config.data.keys) {
        configMap.putIfAbsent(key, () => config.data[key]);
      }

      configs.putIfAbsent(plugin.type, () => configMap);
    }
  }

  static Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  static initPlugins() async {
    for (Plugin plugin in plugins) {
      File file = await PluginService.downloadFile(plugin.downloadUrl, plugin.pluginName);
      plugin.fullLocalPath = file.path;
    }

    Map<String, List<String>> map = {
      'paths': plugins.map((p) => p.fullLocalPath).toList(),
      'types': plugins.map((p) => p.type).toList(),
      'qualifiedClassNames': plugins.map((p) => p.qualifiedName).toList(),
      'pluginNames': plugins.map((p) => p.type).toList(),
    };

    await _pluginChannel.invokeMethod('addConfigs', configs);

    await _pluginChannel.invokeMethod('loadPlugins', map);
  }

  static processThemePlugins() async {
    Map<dynamic, dynamic> res = await _pluginChannel.invokeMethod('processThemePlugins');

    int primary = res['getPrimaryColor()'];
    int secondary = res['getSecondaryColor()'];
    int background = res['getBackground()'];
    bool darkTheme = res['isDarkTheme()'];

    globalTheme = (darkTheme ?? false) ? ThemeData.dark() : ThemeData.light();

    if (res.containsKey('getPrimaryColor()'))
      globalTheme = globalTheme.copyWith(primaryColor: Color(primary).withOpacity(1.0));

    if (res.containsKey('getSecondaryColor()'))
      globalTheme = globalTheme.copyWith(accentColor: Color(secondary).withOpacity(1.0));

    if (res.containsKey('getBackground()'))
      globalTheme = globalTheme.copyWith(backgroundColor: Color(background).withOpacity(1.0));

    appBuilder.state.rebuild();
  }
}
