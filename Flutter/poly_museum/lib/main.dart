import 'package:flutter/material.dart';
import 'package:poly_museum/object_research_game_view.dart';
import 'package:poly_museum/front_view.dart';
import 'package:poly_museum/game_guide_view.dart';
import 'package:poly_museum/guide_view.dart';
import 'package:poly_museum/services/group_service.dart';
import 'package:poly_museum/visitor_view.dart';
import 'ColorChanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color defaultColor = Colors.blue;
    
    GroupService().streamGroups();
    
    return MaterialApp(
      title: 'PolyMuseum',
      theme: ThemeData(primaryColor: defaultColor),
      home: ColoredWidget(child : FrontView(title: 'PolyMuseum Menu'), defaultColor : defaultColor),
      routes: {
        '/FrontView': (context) => ColoredWidget(child : FrontView(title: 'PolyMuseum Menu'), defaultColor : defaultColor),
        '/GuideView': (context) => ColoredWidget(child : GuideView(title: 'PolyMuseum Menu'), defaultColor : defaultColor),
        '/MyHomePage': (context) => ColoredWidget(child : MyHomePage(title: 'PolyMuseum Menu'), defaultColor : defaultColor),
        '/VisitorView': (context) => ColoredWidget(child : ObjectResearchGameView(),  defaultColor : defaultColor),
        '/GameGuideView': (context) => ColoredWidget(child : GameGuideView(title: "Jeu de recherche d'objets"),  defaultColor : defaultColor),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String nomMusee = 'Musée du Sport';

  @override
  void initState() {
    super.initState();

    print('foo');
    Firestore.instance.collection('/Musées/NiceSport/plugins/ChangerCouleurs/config').document('current').get().then((colors) {
        print('bar');
        ColorChanger.of(context)?.color =
          Color.fromARGB(0xFF, colors['color_red'], colors['color_green'], colors['color_blue']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.account_balance),
                        title: Text('Bienvenue au $nomMusee'),
                      ),
                      Image(image: NetworkImage("http://www.museedusport.fr/sites/default/files/logo.png"))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: NetworkImage(
                          'http://www.cigalefm.net/wp-content/uploads/2014/10/ballon-de-foot-traditionnel.jpg'),
                    ),
                  ),
                  Expanded(
                    child: Image(
                      image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/fr/thumb/2/2f/Nice_Logo.svg/285px-Nice_Logo.svg.png"),
                    ),
                  ),
                  Expanded(
                    child: Image(
                        image: NetworkImage(
                            "https://www.basketstore.fr/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/b/a/ballon-nike-hyperelite-oranget6.jpg")),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Rejoindre une visite : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    FlatButton(
                      child: Text('Rejoindre', style: TextStyle(color: Colors.lightBlue.withOpacity(0.7))),
                      onPressed: () => enterCode(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future enterCode() async {
    TextEditingController nameController = new TextEditingController();
    TextEditingController codeController = new TextEditingController();

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Enter group code'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(hintText: 'Nom au sein du groupe'),
                  ),
                  TextFormField(
                    controller: codeController,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: InputDecoration(hintText: 'Code de groupe'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.grey[300],
                      onPressed: () => Navigator.pop(context),
                      child: Text('Valider'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    String name = nameController.text.trim();
    String code = codeController.text.trim();

    GroupService().addMemberToGroup(name, code);

    Navigator.of(context).pushNamed('/VisitorView');
  }
}
