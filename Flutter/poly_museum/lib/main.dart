import 'package:flutter/material.dart';
import 'ColorChanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:poly_museum/simple_plugin_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color defaultColor = Colors.blue;
    
    return MaterialApp(
      title: 'PolyMuseum',
      theme: ThemeData(
        primarySwatch: defaultColor,
      ),
      home: ColoredWidget(
        child : MyHomePage(
          title: 'PolyMuseum Menu'
        ),
        defaultColor : defaultColor
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String nomMusee = 'Musée du Sport';

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    int i = 3;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
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
                      Image(
                          image: NetworkImage(
                              "http://www.museedusport.fr/sites/default/files/logo.png"))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Row(
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      'http://www.cigalefm.net/wp-content/uploads/2014/10/ballon-de-foot-traditionnel.jpg'),
                  height: 100,
                ),
                Image(
                  height: 100,
                  image: NetworkImage(
                      "https://upload.wikimedia.org/wikipedia/fr/thumb/2/2f/Nice_Logo.svg/285px-Nice_Logo.svg.png"),
                ),
                Image(
                    height: 100,
                    image: NetworkImage(
                        "https://www.basketstore.fr/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/b/a/ballon-nike-hyperelite-oranget6.jpg")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Cliquez ici pour rejoindre une visite : ",
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Rejoindre',
                          style: TextStyle(
                              color: Colors.lightBlue.withOpacity(0.6)),
                        ),
                        onPressed: () {
                          enterCode();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SimplePluginView())); */
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }

  @override
  void initState() {
    Firestore.instance.collection('appearance').document('current').get().then((appearance) {
        ColorChanger.of(context).color = Color.fromARGB(0xFF, appearance['color_red'], appearance['color_green'], appearance['color_blue']);
    });
  }

  void enterCode() {}
}
