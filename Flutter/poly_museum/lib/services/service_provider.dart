import 'package:poly_museum/services/group_service.dart';
import 'package:poly_museum/services/object_research_game_service.dart';
import 'package:poly_museum/services/plugin_service.dart';

class ServiceProvider {
  static GroupService _groupService = GroupService();
  static ObjectResearchGameService _gameService = ObjectResearchGameService();
  static PluginService _pluginService = PluginService();

  static GroupService get groupService => _groupService;

  static ObjectResearchGameService get gameService => _gameService;

  static PluginService get pluginService => _pluginService;


}
