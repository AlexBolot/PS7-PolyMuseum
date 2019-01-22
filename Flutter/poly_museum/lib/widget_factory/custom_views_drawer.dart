import 'package:flutter/material.dart';
import 'package:poly_museum/services/service_provider.dart';
import 'package:poly_museum/widget_factory/custom_widget.dart';

class CustomViewsDrawer extends StatefulWidget {
  @override
  _CustomViewsDrawerState createState() => _CustomViewsDrawerState();
}

class _CustomViewsDrawerState extends State<CustomViewsDrawer> {
  Map<String, Map<String, dynamic>> pages = {};
  List<String> names = [];

  @override
  void initState() {
    super.initState();
    pages = ServiceProvider.pluginService.customPages;
    names = pages.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('Activités Libres')),
      body: Container(
        child: ListView.separated(
          itemCount: names.length,
          separatorBuilder: (context, i) => Container(height: 8.0),
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWidget(pages[names[i]])));
              },
              child: Card(
                elevation: 8.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(names[i], style: TextStyle(fontSize: 18.0)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
