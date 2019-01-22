import 'package:flutter/material.dart';
import 'package:poly_museum/services/service_provider.dart';
import 'package:poly_museum/widget_factory/custom_views_drawer.dart';

class VisitorHomePage extends StatefulWidget {
  VisitorHomePage({this.title});

  final String title;

  @override
  _VisitorHomePageState createState() => _VisitorHomePageState();
}

class _VisitorHomePageState extends State<VisitorHomePage> {
  final String nomMusee = 'Musée du Sport';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: CustomViewsDrawer(),
      ),
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

    if (name != "" && code != "") {
      ServiceProvider.groupService.addMemberToGroup(name, code);
    } else if (code == "E84KD") {
      Navigator.of(context).pushNamed('/VisitorView');
    } else {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Le groupe n'existe pas, rééssayez"),
            children: <Widget>[
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
          );
        },
      );
    }
  }
}
