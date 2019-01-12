import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// This is only a temporary view, will be removed soon
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

class SimplePluginView extends StatefulWidget {
  static const String path = '/SimplePluginView';

  @override
  _SimplePluginViewState createState() => _SimplePluginViewState();
}

class _SimplePluginViewState extends State<SimplePluginView> {
  List<String> _list = ["vgvgv"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Plugin View')),
      body: Container(
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, i) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_list[i]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final channel = const MethodChannel('channel:polytech.al.imh/plugin');
          List<String> results = (await channel.invokeMethod('loadPlugins')).cast<String>();

          print(results);

          setState(() => _list.addAll(results));
        },
      ),
    );
  }
}
