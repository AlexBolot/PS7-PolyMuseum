import 'db_structure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poly_museum/model/plugin.dart';

class PluginDAO {
  Firestore _firestore = Firestore.instance;

  PluginDAO();

  void insert(Plugin plugin) {
    DocumentReference pluginRef = _firestore
    .collection(DBStructure.plugins_collection)
    .document(plugin.getIdentifier());

    pluginRef.setData({
        DBStructure.plugin_config_field : plugin.config,
        DBStructure.plugin_download_url_field : plugin.downloadUrl,
        DBStructure.plugin_libelle_field : plugin.libelle,
        DBStructure.plugin_plugin_name_field : plugin.pluginName,
        DBStructure.plugin_qualified_name_field : plugin.qualifiedName,
        DBStructure.plugin_type_field : plugin.type,
    });

    if (plugin.isActivatedInMuseum(plugin.museum)) {
      _firestore
      .collection(DBStructure.museum_collection)
      .document(DBStructure.test_museum_document)
      .collection(DBStructure.museum_plugins_collection)
      .document(plugin.getIdentifier())
      .setData({
          DBStructure.museum_plugins_activated_field : true,
          DBStructure.museum_plugins_reference_field : pluginRef
      });
    }
  }

  void delete(Plugin plugin) {
    /*DocumentReference pluginsCollection = _firestore
      .collection(DBStructure.plugins_collection);

    QuerySnapshot museumPluginsCollection = await _firestore
    .collection(DBStructure.museum_collection)
    .document(DBStructure.test_museum_document)
    .collection(DBStructure.museum_plugins_collection);
    .getDocuments();

    for (DocumentSnapshot doc : museumPluginsCollection) {
      doc.
    }
    */
  }
}
