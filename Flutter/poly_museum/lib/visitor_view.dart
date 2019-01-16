import 'package:flutter/material.dart';

class VisitorView extends StatefulWidget {

  static const String path = '/VisitorView';

  @override
  _VisitorViewState createState() => _VisitorViewState();
}

class _VisitorViewState extends State<VisitorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        child : Center (
          child : Text(VisitorView.path),
        ),
      ),
    );
  }
}
