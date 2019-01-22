import 'package:flutter/material.dart';
import 'package:poly_museum/app_builder.dart';
import 'package:poly_museum/front_view.dart';
import 'package:poly_museum/game_guide_view.dart';
import 'package:poly_museum/global.dart';
import 'package:poly_museum/guide_view.dart';
import 'package:poly_museum/object_research_game_view.dart';
import 'package:poly_museum/services/plugin_service.dart';
import 'package:poly_museum/services/service_provider.dart';
import 'package:poly_museum/visitor_home_page.dart';
import 'app_builder.dart';


void main() => runApp(MyApp());

bool testing = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (testing) {
      ServiceProvider.gameService.testGameService();
      ServiceProvider.groupService.testGroupService();
      ServiceProvider.pluginService.testStreamPluginsData();
    } else {

      ServiceProvider.groupService.streamGroups();

      PluginService pluginService = ServiceProvider.pluginService;

      pluginService.streamPluginsData().then((value) async {
        await pluginService.initPlugins();
        await pluginService.processThemePlugins();
        await pluginService.processCustomViewPlugins();
      });
    }
    appBuilder = AppBuilder(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PolyMuseum',
          theme: globalTheme,
          home: FrontView(title: 'PolyMuseum Menu'),
          routes: {
            '/FrontView': (context) => FrontView(title: 'PolyMuseum Menu'),
            '/GuideView': (context) => GuideView(title: 'PolyMuseum Menu'),
            '/VisitorHomePage': (context) => VisitorHomePage(title: 'PolyMuseum Menu'),
            '/VisitorView': (context) => ObjectResearchGameView(),
            '/GameGuideView': (context) => GameGuideView(title: "Jeu de recherche d'objets"),
          },
        );
      },
    );

    return appBuilder;
  }
}